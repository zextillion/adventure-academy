@tool
extends Trigger
class_name CameraSettingsTrigger

@export var tween_duration := 0.0
@export var zoom := Vector2.ONE

func get_limit_left() -> float:
	return $TopLeft.global_position.x

func get_limit_top() -> float:
	return $TopLeft.global_position.y

func get_limit_right() -> float:
	return $BottomRight.global_position.x

func get_limit_bottom() -> float:
	return $BottomRight.global_position.y

func change_limits() -> void:
	var tweener = create_tween()
	tweener.tween_property(GameManager.gameplay_camera, "limit_left", get_limit_left(), tween_duration)
	tweener.tween_property(GameManager.gameplay_camera, "limit_top", get_limit_top(), tween_duration)
	tweener.tween_property(GameManager.gameplay_camera, "limit_right", get_limit_right(), tween_duration)
	tweener.tween_property(GameManager.gameplay_camera, "limit_bottom", get_limit_bottom(), tween_duration)

func change_zoom() -> void:
	if GameManager.sidescroller_main.respawn_cutscene_playing:
		await GameManager.sidescroller_main.respawn_cutscene_finished
	var tweener = create_tween()
	tweener.tween_property(GameManager.gameplay_camera, "zoom", zoom, tween_duration)

func trigger(_dummy_var=null) -> void:
	change_limits()
	change_zoom()
	super.trigger(_dummy_var)


#########################
## Editor drawing code ##
#########################
@export var line_color := Color("80aff2")
@export var line_width := 2.0


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return
	queue_redraw()

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	
	var points := PackedVector2Array()
	points.append($TopLeft.position)
	points.append(Vector2($BottomRight.position.x, $TopLeft.position.y))
	points.append($BottomRight.position)
	points.append(Vector2($TopLeft.position.x, $BottomRight.position.y))
	points.append($TopLeft.position)
	draw_polyline(points, line_color, line_width)
