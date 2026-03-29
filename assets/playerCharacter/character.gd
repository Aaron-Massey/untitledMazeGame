class_name PlayerCharacter
## A 3D character controller with sprinting, stamina, and mouse look functionality.
##
## This script is designed for a first-person character in a 3D environment. It includes:
## - Basic movement with acceleration and deceleration.
## - Jumping.
## - Sprinting that drains stamina, with recovery when not sprinting.
##   - Recovery is faster when idle compared to walking.
## - Mouse look for camera control, with limits on vertical rotation.
##   - Press ESC to release the mouse, and click to recapture it.
## - Debug input to reset the character's position.
##   - Press 'R' to reset the character to a default position (0,10,0).
##
## The Character object's origin is located at the feet,
## The camera is positioned 1.0 units above the origin

extends CharacterBody3D

@export_category("Movement")
## How quickly the character accelerates when input is given
@export var acceleration: float = 10.0
## How quickly the character decelerates when no input is given
@export var deceleration: float = 15.0
## The maximum speed the character can reach when moving
@export var top_speed: float = 100.0
## The initial velocity applied when the character jumps
@export var jump_velocity: float = 4.5
## A multiplier for acceleration when changing direction to reduce sliding
@export var turn_friction: float = 3.0

@export_category("Sprint & Stamina")
## The speed the character moves at while sprinting
@export var sprint_speed: float = 14.0
## How quickly the character accelerates when starting to sprint
@export var sprint_acceleration: float = 60.0
## The maximum stamina the character can have
@export var max_stamina: float = 100.0
## The rate at which stamina drains while sprinting (units per second)
@export var stamina_drain_rate: float = 25.0
## The rate at which stamina recovers while walking (units per second)
@export var stamina_walk_recovery_rate: float = 10.0
## The rate at which stamina recovers while idle (units per second)
@export var stamina_idle_recovery_rate: float = 35.0

@export_category("Camera Settings")
## The field of view for the camera in degrees
@export var fov: float = 75.0
## The lower limit for vertical camera rotation (looking down) in degrees
@export var tilt_lower_limit: float = -90.0
## The upper limit for vertical camera rotation (looking up) in degrees
@export var tilt_upper_limit: float = 90.0
## The sensitivity of mouse movement for camera control
@export var mouse_sensitivity: float = 0.5

# Internal state variables
## The current stamina of the character, initialized to max_stamina
var current_stamina: float = 100.0
## Whether the character is currently sprinting
var is_sprinting: bool = false
## Whether the character is exhausted and cannot sprint
var is_exhausted: bool = false
## Accumulated yaw input from mouse movement for horizontal rotation
var _yaw_input: float
## Accumulated pitch input from mouse movement for vertical rotation
var _pitch_input: float

## Reference to the camera node for controlling the field of view and rotation
@onready var camera_controller: Camera3D = $Neck/Camera3D


## Initialize the camera settings and stamina when the character is ready
func _ready() -> void:
	camera_controller.fov = fov
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	current_stamina = max_stamina


## Handle mouse input for camera control
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_yaw_input += -event.relative.x * mouse_sensitivity
		_pitch_input += -event.relative.y * mouse_sensitivity


## Main physics process function to handle movement, jumping, sprinting, and camera updates
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	process_other_inputs()
	move(delta)
	update_camera()
	move_and_slide()


## Handle movement input, sprinting logic, and stamina management
func move(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if current_stamina <= 0.0:
		is_exhausted = true
	elif current_stamina >= 20.0:
		is_exhausted = false

	if Input.is_action_pressed("move_sprint") and direction != Vector3.ZERO and not is_exhausted:
		is_sprinting = true
	else:
		is_sprinting = false

	update_stamina(delta)

	var active_speed := sprint_speed if is_sprinting else top_speed
	var active_accel := sprint_acceleration if is_sprinting else acceleration

	var current_xz := Vector3(velocity.x, 0, velocity.z)
	var target_xz: Vector3 = direction * active_speed

	if direction:
		var accel_multiplier := 1.0

		if current_xz.length() > 0.5:
			var momentum_alignment := direction.dot(current_xz.normalized())
			if momentum_alignment < 0.9:
				accel_multiplier = turn_friction

		current_xz = current_xz.move_toward(target_xz, active_accel * accel_multiplier * delta)
	else:
		current_xz = current_xz.move_toward(Vector3.ZERO, deceleration * delta)

	velocity.x = current_xz.x
	velocity.z = current_xz.z


## Update the stamina based on whether the character is sprinting, walking, or idle
func update_stamina(delta: float) -> void:
	if is_sprinting:
		current_stamina -= stamina_drain_rate * delta
	elif velocity.length() > 0.1:
		current_stamina += stamina_walk_recovery_rate * delta
	else:
		current_stamina += stamina_idle_recovery_rate * delta

	current_stamina = clamp(current_stamina, 0.0, max_stamina)


## Update the camera rotation based on mouse input, with limits on vertical rotation
func update_camera() -> void:
	rotate_y(deg_to_rad(_yaw_input))
	camera_controller.rotate_x(deg_to_rad(_pitch_input))

	var lower_limit := deg_to_rad(tilt_lower_limit)
	var upper_limit := deg_to_rad(tilt_upper_limit)
	camera_controller.rotation.x = clamp(camera_controller.rotation.x, lower_limit, upper_limit)

	_yaw_input = 0.0
	_pitch_input = 0.0


## Handle other inputs such as resetting position and mouse capture/release
func process_other_inputs() -> void:
	if Input.is_action_just_pressed("debug_reset"):
		set_pos(Vector3(0, 10, 0))
	if Input.is_action_just_pressed("contain_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_action_just_pressed("release_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


## Set the character's global position and reset velocity to zero
func set_pos(new_pos: Vector3) -> void:
	self.global_position = new_pos
	self.velocity = Vector3.ZERO


## Set the camera angles directly
func set_camera_angles(yaw: float, pitch: float) -> void:
	_yaw_input = yaw
	_pitch_input = pitch
	update_camera()
