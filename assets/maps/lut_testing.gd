extends Node3D

const BASIC_VARIANT = 0

@export var maze_lut: MazeLUT
@export var tile_spacing: float = 10.0
@export var start_offset: Vector3 = Vector3(0, 0, 0)


func _ready():
	# 1. Populate the Dictionary from your MazeRegistry.tscn
	maze_lut.initialize_from_registry()

	for i in range(1, 16):
		# 2. Calculate the specific location for this test tile
		var tile_location = start_offset + Vector3(i * tile_spacing, 0, 0)

		# 3. Use the new centralized function to spawn the tile
		# Note: We pass 'self' so the tiles are added as children of this node
		var new_tile = maze_lut.spawn_tile(i, tile_location, self, BASIC_VARIANT)

		if new_tile:
			print("Instantiated ID: ", i, " at ", new_tile.global_position)
		else:
			# If spawn_tile returns null, it means the ID was missing or the scene failed to load
			push_error("TEST FAILED: Bitmask ID " + str(i) + " could not be spawned.")
