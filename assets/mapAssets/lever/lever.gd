extends Node3D

const LEVER_BOUNDS: Vector2 = Vector2(-35.0, 35.0)

@export var lever_speed: float = 0.5  ## Time in seconds for the animation
@export var active: bool = false

@onready var lever_pivot: Node3D = $Base/ArmPivot


func interact() -> void:
	# Toggle the state
	active = not active

	# Set the angle based on the state
	if active:
		lever_pivot.rotation_degrees.z = -40.0
	else:
		lever_pivot.rotation_degrees.z = 40.0

	# Send a debug print
	print("Lever is now: ", "ON" if active else "OFF")
