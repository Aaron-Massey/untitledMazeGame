extends StaticBody3D

# The speed the door opens at
@export var door_speed: float = 1.0
# Set this in the Inspector to match how many levers are connected to this door
@export var required_levers: int = 2
# Is the door currently open?
@export var is_open: bool = false

var closed_pos: Vector3
var open_pos: Vector3
var _tween: Tween

# This will track how many levers are currently pulled
var _active_levers_count: int = 0


func _ready() -> void:
	closed_pos = self.position
	open_pos = closed_pos + Vector3(0, 3, 0)


func _on_lever_toggled(is_active: bool) -> void:
	# Add or subtract from the total count based on the lever's state
	if is_active:
		_active_levers_count += 1
	else:
		_active_levers_count -= 1

	# Safeguard to ensure the counter doesn't break if a lever bugs out
	_active_levers_count = clampi(_active_levers_count, 0, required_levers)

	# Only open if the active count matches the required amount
	if _active_levers_count >= required_levers:
		open_door()
	else:
		close_door()


func open_door() -> void:
	_animate_door(open_pos)
	print_debug("DOOR OPENED")
	is_open = true


func close_door() -> void:
	_animate_door(closed_pos)
	print_debug("DOOR CLOSED")
	is_open = false


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
