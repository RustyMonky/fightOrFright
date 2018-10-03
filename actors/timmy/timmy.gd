extends KinematicBody2D

enum STATE { REST, MOVING }

var animations
var currentState = STATE.REST
var direction = Vector2(0, 0)
const SPEED = 2

func _ready():
	animations = $animations
	set_process(true)
	set_process_input(true)

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		direction = Vector2(0, -1)
		move_timmy()
	elif Input.is_action_pressed("ui_down"):
		direction = Vector2(0, 1)
		move_timmy()
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2(-1, 0)
		move_timmy()
	elif Input.is_action_pressed("ui_right"):
		direction = Vector2(1, 0)
		move_timmy()

	if currentState == STATE.REST:
		if animations.is_playing():
			animations.stop()
			animations.set_frame(0)

func _input(event):
	if currentState == STATE.MOVING:
		if event.is_action_released("ui_up") || event.is_action_released("ui_down") || event.is_action_released("ui_left") || event.is_action_released("ui_right"):
			currentState = STATE.REST

func move_timmy():
	currentState = STATE.MOVING
	self.move_and_collide(direction * SPEED)

	# Check change in direction to update animation flip
	if direction.x == 1:
		animations.flip_h = true
	elif direction.x == -1:
		animations.flip_h = false

	animations.play()