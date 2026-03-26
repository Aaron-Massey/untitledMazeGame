@tool
extends Node3D

@export var size : Vector2 = Vector2(1, 1):
	set(value):
		size = value
		update_mesh()

# Let's add exports to customize the grid if you want!
@export_group("Grid Colors")
@export var light_color: Color = Color(0.7, 0.7, 0.7):
	set(value):
		light_color = value
		update_mesh()

@export var dark_color: Color = Color(0.5, 0.5, 0.5):
	set(value):
		dark_color = value
		update_mesh()
		
@onready var body = $StaticBody3D
@onready var collider = $StaticBody3D/CollisionShape3D
@onready var mesh = $StaticBody3D/MeshInstance3D

# Load the shader file we just created
@onready var grid_shader = preload("res://assets/mapAssets/testPlatform/test_grid.gdshader")

func _ready() -> void:
	update_mesh()

func update_mesh() -> void:
	if not is_node_ready():
		return
	
	mesh.mesh.size = size
	
	collider.shape.size = Vector3(size.x, 0.1, size.y)
	
	var mat = ShaderMaterial.new()
	mat.shader = grid_shader
	
	mat.set_shader_parameter("color_light", light_color)
	mat.set_shader_parameter("color_dark", dark_color)
	
	mesh.material_override = mat
