extends Node

onready var changeTimer = $changeTimer
onready var spawnTimer = $spawnTimer
onready var viewport = get_parent().get_node("viewport")

func _ready():
	pass

func _on_spawnTimer_timeout():
	if get_tree().get_nodes_in_group("enemies").size() >= 20:
		return

	randomize()
	# Create a new enemy on every timeout
	var enemy = load("res://actors/enemies/skeleton/skeleton.tscn").instance()
	var spawnHeight = int(rand_range(32, viewport.size.y - 64)) # Temporary

	# Determine side of the screen
	var sideId = randi() % 2
	if sideId == 0:
		enemy.position = Vector2(-32, spawnHeight)
		enemy.direction = Vector2(1, 0)
	else:
		enemy.position = Vector2(viewport.size.x + 32, spawnHeight)
		enemy.direction = Vector2(-1, 0)
		enemy.get_node("animations").flip_h = true
	get_parent().add_child(enemy) # Assumes parent is level scene!
	
func _on_changeTimer_timeout():
	spawnTimer.wait_time = 0.5
	changeTimer.wait_time = 60
