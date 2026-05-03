extends Node3D

@onready var anim_tree = $AnimatableBody3D/AnimationTree
@onready var music_player = $AudioStreamPlayer3D

# This grabs the "brain" of the State Machine
@onready var playback = anim_tree.get("parameters/playback")


func _ready():
	# Make sure the tree is active from the start so the Idle state plays
	anim_tree.active = true


func start_dancing():
	# Command the State Machine to smoothly transition to our nested Dance node
	if playback:
		playback.travel("Dance")

	if music_player:
		music_player.play()
