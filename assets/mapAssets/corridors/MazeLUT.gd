class_name MazeLUT
extends Resource

# Dictionary where the key is the Bitmask ID (0-15)
# The bit stores an open side to a tile
# 0001(1) = +X
# 0010(2) = -X
# 0100(4) = +Z
# 1000(8) = -Z

@export var registry_scene: PackedScene
@export var lookup: Dictionary = {}


# Call this to initialize the dictionary from the scene
func initialize_from_registry():
	var registry_node = registry_scene.instantiate()

	# Iterate through variants (e.g., Variant_0_Base)
	for variant in registry_node.get_children():
		if variant is Node3D and variant.name != "Lables":
			# Iterate through the tiles
			for tile in variant.get_children():
				# Extract the bitmask ID
				var bitmask_id = _extract_id(tile.name)

				# Store the reference and its rotation
				if not lookup.has(bitmask_id):
					lookup[bitmask_id] = []

				lookup[bitmask_id].append(
					{
						"scene_path": tile.scene_file_path,
						"transform": tile.transform,
						"can_constain_lever": tile.get_meta("can_hold_lever", false)
					}
				)

	registry_node.queue_free()


func _extract_id(node_name: String) -> int:
	# Removes all non-numeric characters before converting
	var regex = RegEx.new()
	regex.compile("\\d+")  # Matches digits
	var result = regex.search(node_name)
	if result:
		return result.get_string().to_int()
	return 0


func spawn_tile(id: int, location: Vector3, parent_node: Node3D, variant_index: int = 0) -> Node3D:
	if not lookup.has(id):
		push_error("Bitmask ID %d not found in LUT" % id)
		return null

	var data_list = lookup[id]
	var data = data_list[variant_index] if variant_index < data_list.size() else data_list[0]

	var scene = load(data.scene_path)
	if scene:
		var instance = scene.instantiate()
		parent_node.add_child(instance)
		instance.transform = data.transform
		instance.global_position = location

		return instance
	return null
