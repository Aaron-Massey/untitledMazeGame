extends Node3D

const LEVER_BOUNDS: Vector2 = Vector2(-35.0, 35.0)

@export var lever_speed: float = 0.5  ## Time in seconds for the animation
@export var active: bool = false

@onready var lever_pivot: Node3D = $Base/ArmPivot


func interact() -> void:
	# Toggle the state
	active = not active

	# Create a tween for the rotation animation
	var tween = create_tween()

	# Set the angle based on the state
	var target_rotation: float = 40.0 if active else -40.0

	(
		tween
		. tween_property(lever_pivot, "rotation_degrees:z", target_rotation, lever_speed)
		. set_trans(Tween.TRANS_QUAD)
		. set_ease(Tween.EASE_IN_OUT)
	)

	# Send a debug print
	print("Lever is now: ", "ON" if active else "OFF")
