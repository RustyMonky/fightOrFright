extends Node2D

onready var tilemap = $tilemap
onready var timmy = $timmy
onready var audio = $backgroundMusic

var hasGameover = false

func _ready():
	timmy.position = tilemap.map_to_world(Vector2(12, -4)) # Set timmy in center of the tilemap

func _on_triggerZone_body_entered(body):
	if body.is_in_group("enemies"):
		body.move_to_timmy()

func _on_gameTime_timeout():
	if timmy.currentState != timmy.STATE.DEAD:
		if gameData.secondsAlive + 1 == 60:
			gameData.minutesAlive += 1
			gameData.secondsAlive = 0
		else:
			gameData.secondsAlive += 1

	elif !hasGameover:
		hasGameover = true
		var gameoverScene = load("res://scenes/gameover/gameover.tscn").instance()
		self.add_child(gameoverScene)
		audio.stop()
