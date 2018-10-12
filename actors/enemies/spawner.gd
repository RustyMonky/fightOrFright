extends Node

onready var spawnTimer = $spawnTimer

func _ready():
	pass

func _on_spawnTimer_timeout():
	randomize()
	# Create a new enemy on every timeout
	var enemy = load("res://actors/enemies/skeleton/skeleton.tscn").instance()
	var spawnHeight = int(rand_range(32, int(OS.window_size.y - 64))) # Temporary

	# Determine side of the screen
	var sideId = randi() % 2
	if sideId == 0:
		enemy.position = Vector2(-32, spawnHeight)
		enemy.direction = Vector2(1, 0)
	else:
		enemy.position = Vector2(int(OS.window_size.x + 32), spawnHeight)
		enemy.direction = Vector2(-1, 0)
		enemy.get_node("animations").flip_h = true
	get_parent().add_child(enemy) # Assumes parent is level scene!
	
