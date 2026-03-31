extends Node3D

@export var lantern_on = true
@onready var oil_lantern = $"Sketchfab_Scene/Sketchfab_model/4b17dd9eba0245778cead7ee8fe19576_fbx/RootNode/Oil Lantern"
func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("lantern"):
		if lantern_on == true:
			$OmniLight3D.light_energy = 0
			lantern_on = false
		else:
			$OmniLight3D.light_energy = 4
			lantern_on = true
			
		oil_lantern.set_lit(lantern_on)
	
