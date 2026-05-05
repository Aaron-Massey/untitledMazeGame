extends Node3D

signal toggled(is_active: bool)

const LEVER_BOUNDS: Vector2 = Vector2(-35.0, 35.0)

@export var lever_speed: float = 0.5
@export var active: bool = false

var _tween: Tween

@onready var lever_pivot: Node3D = $lever_base/ArmPivot


func interact() -> void:
	active = not active
	toggled.emit(active)

	if _tween:
		_tween.kill()

	_tween = create_tween()
	var target_rotation: float = LEVER_BOUNDS.y if active else LEVER_BOUNDS.x

	(
		_tween
		. tween_property(lever_pivot, "rotation_degrees:z", target_rotation, lever_speed)
		. set_trans(Tween.TRANS_QUAD)
		. set_ease(Tween.EASE_IN_OUT)
	)

	print("Lever signal emitted: ", active)
