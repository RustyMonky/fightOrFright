extends Control

onready var credits = $creditBox

func _ready():
	reset_position()
	set_process_input(true)

	set_physics_process(true)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		reset_position()
		self.hide()

func _physics_process(delta):
	if self.visible:
		credits.rect_position.y -= 0.5

func reset_position():
	credits.rect_position = Vector2(0, 360)
