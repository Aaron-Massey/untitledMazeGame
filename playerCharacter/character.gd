extends CharacterBody3D
@export_category("Movement")
@export var acceleration : float = 10.0
@export var deceleration : float = 15.0
@export var topSpeed : float = 100.0
@export var jumpVelocity : float = 4.5
@export_category("Camera Settings")
@export var FOV : float = 75
@export var TILT_LOWER_LIMIT : float = -90
@export var TILT_UPPER_LIMIT : float = 90
@export var MOUSE_SENSITIVITY : float = 0.5


@onready var CAMERA_CONTROLLER = $Neck/Camera3D

var _yaw_input : float #Camera left and right
var _pitch_input : float #Camera up and down

func _ready() -> void:
	CAMERA_CONTROLLER.fov = FOV;
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_yaw_input += -event.relative.x * MOUSE_SENSITIVITY
		_pitch_input += -event.relative.y * MOUSE_SENSITIVITY

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move(delta)
	updateCamera(delta)
	move_and_slide()
	

func move(delta) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpVelocity

	# Get the input direction
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Isolate our X/Z movement from our Y (gravity/jump) movement
	var current_xz := Vector3(velocity.x, 0, velocity.z)
	var target_xz : Vector3 = direction * topSpeed
	
	if direction:
		# Accelerate the vector as a whole
		current_xz = current_xz.move_toward(target_xz, acceleration * delta)
	else:
		# Decelerate the vector as a whole
		current_xz = current_xz.move_toward(Vector3.ZERO, deceleration * delta)
		
	# Apply the newly calculated X/Z values back to the actual velocity
	velocity.x = current_xz.x
	velocity.z = current_xz.z

func updateCamera(delta) -> void:
	rotate_y(deg_to_rad(_yaw_input))
	
	CAMERA_CONTROLLER.rotate_x(deg_to_rad(_pitch_input))
	
	var lowerLimit = deg_to_rad(TILT_LOWER_LIMIT)
	var upperLimit = deg_to_rad(TILT_UPPER_LIMIT)
	CAMERA_CONTROLLER.rotation.x = clamp(CAMERA_CONTROLLER.rotation.x, lowerLimit, upperLimit)
	
	_yaw_input = 0.0
	_pitch_input = 0.0
