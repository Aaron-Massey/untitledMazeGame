extends Node3D

# Export these so we can drag-and-drop the specific nodes in the Inspector
@export var player: CharacterBody3D
@export var end_marker: Marker3D


func _process(_delta):
	# --- CHEAT 1: TELEPORT TO END ---
	if Input.is_action_just_pressed("cheatEnd"):
		if player and end_marker:
			# We can use your custom function instead of manually setting it!
			player.set_pos(end_marker.global_position)
			print("Cheat: Teleported to End")

	# --- CHEAT 2: FORCE ALL LEVERS ON ---
	if Input.is_action_just_pressed("cheatDoors"):
		# Grab every node in the "Levers" group
		var all_levers = get_tree().get_nodes_in_group("Levers")

		for lever in all_levers:
			# Make sure this node actually has your interact method
			if lever.has_method("interact"):
				# ONLY pull the lever if it isn't active yet!
				if not lever.active:
					lever.interact()

		print("Cheat: All doors/levers forced active!")
