extends Area3D

# Instead of exporting the tree and music, we export the whole Maxwell instance
@export var maxwell_instance: Node3D

var has_triggered = false


func _on_body_entered(body):
	print("SOMETHING ENTERED: ", body.name)  # Add this line!
	if body is PlayerCharacter and not has_triggered:
		print("THAT SOMETHING IS A PLAYER")  # Add this line!
		has_triggered = true

		# Check if we assigned Maxwell, and if he has our custom function
		if maxwell_instance and maxwell_instance.has_method("start_dancing"):
			maxwell_instance.start_dancing()
