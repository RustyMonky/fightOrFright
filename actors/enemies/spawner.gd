extends Node

onready var spawnTimer = $spawnTimer

func _ready():
	pass

func _on_spawnTimer_timeout():
	randomize()
	# Create a new enemy on every timeout
	var enemy = load("res://actors/enemies/skeleton/skeleton.tscn").instance()
	var spawnHeight = int(rand_range(32, int(OS.window_size.y))) #randi() % int(OS.window_size.y) # Temporary
	enemy.position = Vector2(-32, spawnHeight)
	get_parent().add_child(enemy) # Assumes parent is level scene!
	
