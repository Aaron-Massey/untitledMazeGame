extends Label3D

var max_scale = Vector3(1.5, 1.5, 1.5)
var min_scale = Vector3(.5, .5, .5)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


func grow_and_shrink():
	var tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)

	tween.tween_property(self, "scale", max_scale, 2.0)

	tween.tween_property(self, "scale", min_scale, 2.0)
