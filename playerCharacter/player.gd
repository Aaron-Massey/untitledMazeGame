extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _update() -> void:
	if(KEY_W):
		self.position[0] += .01;
	if(KEY_A):
		self.position[1] -= .01;
	if(KEY_S):
		self.position[0] -= .01;
	if(KEY_D):
		self.position[1] += .01;
