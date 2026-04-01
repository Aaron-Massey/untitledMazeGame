extends Node3D
@export_category("Columns")
@export var negative_x_positive_z: bool = true
@export var negative_x_negative_z: bool = true
@export var positive_x_positive_z: bool = true
@export var positive_x_negative_z: bool = true

@export_category("Walls")
@export var negative_x: bool = true
@export var positive_x: bool = true
@export var negative_z: bool = true
@export var positive_z: bool = true

@export var update: bool = false

# Wall Objects
@onready var wall_nx = $"Walls/Wall (-X)"
@onready var wall_px = $"Walls/Wall (+X)"
@onready var wall_nz = $"Walls/Wall (-Z)"
@onready var wall_pz = $"Walls/Wall (+Z)"

# Pillar Objects
@onready var pil_nxpz = $"Corners/CornerPillar (-x,+z)"
@onready var pil_nxnz = $"Corners/CornerPillar (-x,-z)"
@onready var pil_pxpz = $"Corners/CornerPillar (+x,+z)"
@onready var pil_pxnz = $"Corners/CornerPillar (+x,-z)"


func _process(_delta: float) -> void:
	if update:
		refresh_visuals()
		update = false


func update_component(part: Node3D, state: bool):
	# Toggle visibility of the root Node3D
	part.visible = state

	var body = part.get_node_or_null("StaticBody3D")
	if body:
		var shape = body.get_node_or_null("CollisionShape3D")
		if shape:
			shape.set_deferred("disabled", not state)


func refresh_visuals():
	# Walls
	update_component(wall_nx, negative_x)
	update_component(wall_px, positive_x)
	update_component(wall_nz, negative_z)
	update_component(wall_pz, positive_z)

	# Columns
	update_component(pil_pxnz, positive_x_negative_z)
	update_component(pil_nxnz, negative_x_negative_z)
	update_component(pil_pxpz, positive_x_positive_z)
	update_component(pil_nxpz, negative_x_positive_z)
