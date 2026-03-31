extends Node3D

@onready var candle_mesh = $"Oil Lantern_oil lantern light_0"

func set_lit(is_lit: bool) -> void:
	var mat = candle_mesh.get_active_material(0)
	if mat:
		mat.emission_enabled = is_lit
	else:
		print("Override material not set yet")
