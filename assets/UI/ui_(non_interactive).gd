extends CanvasLayer


func _ready() -> void:
	_make_click_through(self)


## Recursively goes through every single node inside the CanvasLayer
## and forces it to ignore the mouse.
func _make_click_through(current_node: Node) -> void:
	# If the node is a UI element, turn off its mouse filter
	if current_node is Control:
		current_node.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Check all the children of this node and run the same function
	for child in current_node.get_children():
		_make_click_through(child)
