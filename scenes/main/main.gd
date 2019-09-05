extends Node2D

onready var audio = $backgroundMusic
onready var timmy = $navi/timmy

var hasGameover = false

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
