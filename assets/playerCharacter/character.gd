extends CharacterBody3D

@export_category("Movement")
@export var acceleration: float = 10.0
@export var deceleration: float = 15.0
@export var top_speed: float = 100.0
@export var jump_velocity: float = 4.5
@export var turn_friction: float = 3.0

@export_category("Sprint & Stamina")
@export var sprint_speed: float = 14.0
@export var sprint_acceleration: float = 60.0
@export var max_stamina: float = 100.0
@export var stamina_drain_rate: float = 25.0
@export var stamina_walk_recovery_rate: float = 10.0
@export var stamina_idle_recovery_rate: float = 35.0

@export_category("Camera Settings")
@export var fov: float = 75.0
@export var tilt_lower_limit: float = -90.0
@export var tilt_upper_limit: float = 90.0
@export var mouse_sensitivity: float = 0.5

# Standard variables come before @onready variables
var current_stamina: float = 100.0
var is_sprinting: bool = false
var is_exhausted: bool = false
var _yaw_input: float
var _pitch_input: float

@onready var camera_controller: Camera3D = $Neck/Camera3D


func _ready() -> void:
	camera_controller.fov = fov
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	current_stamina = max_stamina


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_yaw_input += -event.relative.x * mouse_sensitivity
		_pitch_input += -event.relative.y * mouse_sensitivity


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	process_other_inputs()
	move(delta)
	update_camera()
	move_and_slide()


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

	if is_sprinting:
		current_stamina -= stamina_drain_rate * delta
	elif direction != Vector3.ZERO:
		current_stamina += stamina_walk_recovery_rate * delta
	else:
		current_stamina += stamina_idle_recovery_rate * delta

	current_stamina = clamp(current_stamina, 0.0, max_stamina)

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


func update_camera() -> void:
	rotate_y(deg_to_rad(_yaw_input))
	camera_controller.rotate_x(deg_to_rad(_pitch_input))

	var lower_limit := deg_to_rad(tilt_lower_limit)
	var upper_limit := deg_to_rad(tilt_upper_limit)
	camera_controller.rotation.x = clamp(camera_controller.rotation.x, lower_limit, upper_limit)

	_yaw_input = 0.0
	_pitch_input = 0.0


func process_other_inputs() -> void:
	if Input.is_action_just_pressed("debug_reset"):
		set_pos(Vector3(0, 10, 0))
	if Input.is_action_just_pressed("contain_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_action_just_pressed("release_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func get_pos() -> Vector3:
	return self.position


func set_pos(new_pos: Vector3) -> void:
	self.global_position = new_pos
	self.velocity = Vector3.ZERO
