extends Node3D

@onready var candle_mesh = $"Oil Lantern_oil lantern light_0"
@onready var fire = $GPUParticles3D

func set_lit(value: float) -> void:
	var mat = candle_mesh.get_active_material(0)
	if mat:
		mat.emission_enabled = value > 0.0
		mat.emission_energy_multiplier = value
	fire.emitting = value > 0.0
	if value == 0.0:
		fire.restart()
		fire.emitting = false
