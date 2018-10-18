extends Control

onready var mobsLabel = $canvas/centerBox/mobsLabel
onready var timesLabel = $canvas/centerBox/timeLabel

func _ready():
	mobsLabel.text = String(gameData.mobsKilled) + ' mobs slain'
	timesLabel.text = formattedTime() + ' spent alive'

	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		sceneManager.goto_scene("res://levels/title.tscn")

func formattedTime():
	if gameData.secondsAlive < 10:
		gameData.secondsAlive = '0' + String(gameData.secondsAlive)
	return String(gameData.minutesAlive) + ':' + String(gameData.secondsAlive)
	