extends Control

onready var mobsLabel = $canvas/centerBox/mobsLabel
onready var timesLabel = $canvas/centerBox/timeLabel

func _ready():
	mobsLabel.text = String(gameData.mobsKilled) + ' mobs slain'
	timesLabel.text = formattedTime() + ' spent alive'

func formattedTime():
	if gameData.secondsAlive < 10:
		gameData.secondsAlive = '0' + String(gameData.secondsAlive)
	return String(gameData.minutesAlive) + ':' + String(gameData.secondsAlive)
	