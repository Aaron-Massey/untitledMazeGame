extends Node3D

@export var lantern_on = true
@onready var oil_lantern = $"Sketchfab_Scene/Sketchfab_model/4b17dd9eba0245778cead7ee8fe19576_fbx/RootNode/Oil Lantern"
@onready var target = $"../SpringArm3D/TargetPoint"

func _ready() -> void:
	$OmniLight3D.light_energy = 3.0 if lantern_on else 0.0
	oil_lantern.set_lit(1.0 if lantern_on else 0.0)

func _process(delta):
	global_transform.origin = target.global_transform.origin + Vector3(0, -0.5, 0)

func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("lantern"):
		lantern_on = !lantern_on
		
		var tween = create_tween().set_parallel(true)
		var target_energy = 3.0 if lantern_on else 0.0
		
		tween.tween_property($OmniLight3D, "light_energy", target_energy, 0.2)
		tween.tween_method(oil_lantern.set_lit, 0.0 if lantern_on else 1.0, 1.0 if lantern_on else 0.0, 0.2)
	
