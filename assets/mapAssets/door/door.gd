extends StaticBody3D

@export var door_speed: float = 1.0

var closed_pos: Vector3
var open_pos: Vector3
var _tween: Tween


func _ready() -> void:
	closed_pos = self.position
	open_pos = closed_pos + Vector3(0, 3, 0)


func _on_lever_toggled(is_active: bool) -> void:
	if is_active:
		open_door()
	else:
		close_door()


func open_door() -> void:
	_animate_door(open_pos)
	print_debug("DOOR OPENED")


func close_door() -> void:
	_animate_door(closed_pos)
	print_debug("DOOR CLOSED")


func _animate_door(target_pos: Vector3) -> void:
	if _tween:
		_tween.kill()

	_tween = create_tween()

	# Using TRANS_CUBIC and EASE_OUT makes heavy doors feel more natural
	(
		_tween
		. tween_property(self, "position", target_pos, door_speed)
		. set_trans(Tween.TRANS_CUBIC)
		. set_ease(Tween.EASE_OUT)
	)
