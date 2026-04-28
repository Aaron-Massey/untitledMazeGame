extends Node3D

@onready var world_env = $BaseMap/WorldEnvironment

## Enables full bright for devs
@export var dev_full_bright: bool = false:
	set(value):
		dev_full_bright = value
		if world_env:
			world_env.environment.ambient_light_energy = 1.0 if value else 0.005

func _ready() -> void:
	world_env.environment.ambient_light_energy = 1.0 if dev_full_bright else 0.005
