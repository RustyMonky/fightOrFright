extends Node

enum STATE {TITLE, MAIN}

onready var changeTimer = $changeTimer
onready var spawnTimer = $spawnTimer
onready var viewport = get_parent().get_node("viewport")

var currentMode
var spawnHeight
var spawnSpeedLevel = 1

func _ready():
	if get_parent().has_node("timmy"):
		currentMode = STATE.MAIN
	else:
		currentMode = STATE.TITLE
		spawnTimer.set_wait_time(2)
		spawnTimer.set_autostart(false)

func _on_spawnTimer_timeout():
	if get_tree().get_nodes_in_group("enemies").size() >= 20:
		return

	randomize()
	# Create a new enemy on every timeout
	var enemy = load("res://actors/enemies/skeleton/skeleton.tscn").instance()
	if currentMode == STATE.TITLE:
		spawnHeight = int(viewport.size.y - 32)
	else:
		spawnHeight = int(rand_range(32, viewport.size.y - 64))

	# Determine side of the screen
	var sideId = randi() % 2

	if sideId == 0 || currentMode == STATE.TITLE:
		enemy.position = Vector2(-32, spawnHeight)
		enemy.direction = Vector2(1, 0)
		get_parent().add_child(enemy)
	else:
		enemy.position = Vector2(viewport.size.x + 32, spawnHeight)
		enemy.direction = Vector2(-1, 0)
		enemy.get_node("animations").flip_h = true
		get_parent().get_node("navi").add_child(enemy) # Assumes parent is level scene!

	enemy.speed += (8 * spawnSpeedLevel)
	
func _on_changeTimer_timeout():
	if currentMode == STATE.TITLE:
		return
	spawnTimer.wait_time = (spawnTimer.wait_time * 0.5)
	changeTimer.wait_time = 60
	spawnSpeedLevel += 1
