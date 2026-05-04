extends Node3D

@onready var candle_mesh = $"Oil Lantern_oil lantern light_0"
@onready var fire = $GPUParticles3D


func set_lit(value: float) -> void:
	var mat = candle_mesh.get_active_material(0)

	if mat is ShaderMaterial:
		# Use set_shader_parameter instead of dot-property access
		mat.set_shader_parameter("emission_amount", value)

	fire.emitting = value > 0.0

	if value == 0.0:
		fire.restart()
		fire.emitting = false
