extends Node3D

@export var lantern_on = true

func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("lantern"):
		if lantern_on == true:
			$OmniLight3D.light_energy = 0
			lantern_on = false
		else:
			$OmniLight3D.light_energy = 4
			lantern_on = true
			
			
	
