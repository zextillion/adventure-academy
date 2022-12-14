extends Node

signal screen_transition_finished

const STAGE_PATHS := {
	"HORIZON_HILLS_SMALL_CAVE" : "res://assets/stages/horizon_hills/horizon_hills_small_cave.tscn",
	"HORIZON_HILLS_COMBAT_CAVE_TUTORIAL" : "res://assets/stages/horizon_hills/horizon_hills_combat_cave_tutorial.tscn",
	"HORIZON_HILLS_CAVE_ENTRANCE" : "res://assets/stages/horizon_hills/horizon_hills_cave_entrance.tscn"
}

var actors := {}
var actors_original_cutscene_mode_value := {}
var sidescroller_main: SidescrollerMain
var popup_canvas: CanvasLayer
var current_stage_id: String

var cutscene_mode: bool:
	set(value):
		cutscene_mode = value
		if value:
			actors_original_cutscene_mode_value.clear()
			for actor in actors.values():
				actors_original_cutscene_mode_value[actor] = actor.cutscene_mode
				actor.set_cutscene_mode(true)
			show_cutscene_bars(1.0)
		else:
			for actor in actors.values():
				if actors_original_cutscene_mode_value.has(actor):
					actor.set_cutscene_mode(actors_original_cutscene_mode_value[actor])
				else:
					actor.set_cutscene_mode(false)
			hide_cutscene_bars(1.0)

var player: Actor2D
var gameplay_camera: Camera2D
var transition_camera: Camera2D


func show_cutscene_bars(duration:= 1.0) -> void:
	if is_equal_approx(duration, 0.0):
		$CutsceneBars/Control/AnimationPlayer.play("showing")
	else:
		$CutsceneBars/Control/AnimationPlayer.playback_speed = 1.0 / duration
		$CutsceneBars/Control/AnimationPlayer.play("show_bars")


func hide_cutscene_bars(duration:= 1.0) -> void:
	if is_equal_approx(duration, 0.0):
		$CutsceneBars/Control.visible = false
	else:
		$CutsceneBars/Control/AnimationPlayer.playback_speed = 1.0 / duration
		$CutsceneBars/Control/AnimationPlayer.play("hide_bars")

func enable_gameplay_camera_current(transition_time := 1.0) -> void:
	set_gameplay_camera_current(true, transition_time)

func set_gameplay_camera_current(value: bool, _transition_time := 1.0) -> void:
	if value:
#		var current_camera = get_viewport().get_camera_2d()
#		transition_camera.global_position = current_camera.global_position
#		transition_camera.zoom = current_camera.zoom
#		transition_camera.limit_bottom = current_camera.limit_bottom
#		transition_camera.limit_left = current_camera.limit_left
#		transition_camera.limit_right = current_camera.limit_right
#		transition_camera.limit_top = current_camera.limit_top
#
#		transition_camera.current = true
#		var tweener = create_tween()
#		tweener.set_parallel(true)
#		tweener.tween_property(transition_camera, "global_position", gameplay_camera.global_position, transition_time)
#		tweener.tween_property(transition_camera, "zoom", gameplay_camera.zoom, transition_time)
#		tweener.tween_property(transition_camera, "limit_bottom", gameplay_camera.limit_bottom, transition_time)
#		tweener.tween_property(transition_camera, "limit_left", gameplay_camera.limit_left, transition_time)
#		tweener.tween_property(transition_camera, "limit_right", gameplay_camera.limit_right, transition_time)
#		tweener.tween_property(transition_camera, "limit_top", gameplay_camera.limit_top, transition_time)
#
#		await tweener.finished
		gameplay_camera.current = true
	else:
		gameplay_camera.current = false


func screen_transition(animation: Enums.ScreenTransition, duration:=1.0) -> void:
	var animation_player: AnimationPlayer = $ScreenTransition/AnimationPlayer
	animation_player.playback_speed = 1.0 / duration
	var dict := {
		Enums.ScreenTransition.DEFAULT: "fade_in",
		Enums.ScreenTransition.FADE_IN: "fade_in",
		Enums.ScreenTransition.FADE_OUT: "fade_out"
	}
	animation_player.play(dict[animation])
	await animation_player.animation_finished
	screen_transition_finished.emit()


func request_stage_change(stage_id: String, player_entry_point := 0) -> void:
	var stage = load(STAGE_PATHS[stage_id])
	current_stage_id = stage_id
	sidescroller_main.change_stage(stage, player_entry_point)


func reload() -> void:
	var stage = load(STAGE_PATHS[SaveData.stage_id])
	sidescroller_main.change_stage(stage, 0, true)
