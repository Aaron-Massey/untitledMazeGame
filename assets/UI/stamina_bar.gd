extends ProgressBar

@export var fade_speed: float = 4.0
@onready var player: PlayerCharacter = $"../../.."


func _ready() -> void:
	# Set the UI bar's max value to match the player's max stamina
	self.max_value = player.max_stamina
	self.value = player.current_stamina

	# Start invisible
	self.modulate.a = 0.0


func _process(delta: float) -> void:
	# Update the visual bar to match the player's actual stamina math
	self.value = player.current_stamina

	# Fade logic
	if player.current_stamina < player.max_stamina:
		# If stamina is draining or recovering, fade the bar IN (alpha to 1.0)
		self.modulate.a = move_toward(self.modulate.a, 1.0, fade_speed * delta)
	else:
		# If stamina is 100% full, fade the bar OUT (alpha to 0.0)
		self.modulate.a = move_toward(self.modulate.a, 0.0, fade_speed * delta)
