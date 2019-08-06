extends Control

enum OPTIONS {PLAY, HELP, CREDITS, QUIT}

onready var bgAudio = $backgroundMusic
onready var credits = $credits
onready var effectAudio = $effectAudio
onready var help = $help
onready var optionLabels = $optionsVBox.get_children()

var currentOption

func _ready():
	currentOption = OPTIONS.PLAY
	updateHoveredOption()

	set_process_input(true)

func _input(event):
	if help.is_visible() || credits.is_visible():
		return

	elif event.is_action_pressed("ui_accept"):
		if currentOption == OPTIONS.PLAY:
			bgAudio.stop()
			effectAudio.play()
			fader.fadeToScene("res://scenes/main/main.tscn")
		elif currentOption == OPTIONS.HELP:
			help.show()
		elif currentOption == OPTIONS.CREDITS:
			credits.show()
		elif currentOption == OPTIONS.QUIT:
			get_tree().quit()

	elif event.is_action_pressed("ui_down"):
		if currentOption == OPTIONS.PLAY:
			currentOption = OPTIONS.HELP
		elif currentOption == OPTIONS.HELP:
			currentOption = OPTIONS.CREDITS
		else:
			currentOption = OPTIONS.QUIT
		updateHoveredOption()

	elif event.is_action_pressed("ui_up"):
		if currentOption == OPTIONS.HELP:
			currentOption = OPTIONS.PLAY
		elif currentOption == OPTIONS.CREDITS:
			currentOption = OPTIONS.HELP
		else:
			currentOption = OPTIONS.CREDITS
		updateHoveredOption()

func updateHoveredOption():
	for label in optionLabels:
		if currentOption == optionLabels.find(label):
			label.set("custom_colors/font_color", Color("#c93038"))
		else:
			label.set("custom_colors/font_color", Color("#ffffff"))