extends Node2D

onready var timmy = $timmy

var hasGameover = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

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
		var gameoverScene = load("res://levels/gameover.tscn").instance()
		self.add_child(gameoverScene)
