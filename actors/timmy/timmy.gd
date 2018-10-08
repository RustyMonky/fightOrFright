extends KinematicBody2D

enum STATE { REST, MOVING, DEAD }

onready var animations = $animations
var currentState = STATE.REST
var direction = Vector2(0, 0)
var hp = 3
const SPEED = 2

func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	if currentState == STATE.DEAD:
		return

	if Input.is_action_pressed("ui_up"):
		self.direction = Vector2(0, -1)
		move_timmy()
	elif Input.is_action_pressed("ui_down"):
		self.direction = Vector2(0, 1)
		move_timmy()
	elif Input.is_action_pressed("ui_left"):
		self.direction = Vector2(-1, 0)
		move_timmy()
	elif Input.is_action_pressed("ui_right"):
		self.direction = Vector2(1, 0)
		move_timmy()

	if currentState == STATE.REST:
		if animations.is_playing():
			animations.stop()
			animations.set_frame(0)

func _input(event):
	# Bullet functionality does not depend on MOVING or REST states
	if event.is_action_pressed("ui_select"):
		fire()

	if currentState == STATE.MOVING:
		if event.is_action_released("ui_up") || event.is_action_released("ui_down") || event.is_action_released("ui_left") || event.is_action_released("ui_right"):
			currentState = STATE.REST

func fire():
	var bulletInstance = load("res://actors/projectiles/bullet/bullet.tscn").instance()

	# Unfortunately, bullet position is hard set so that it exits the gun sprite
	if (!animations.flip_h):
		bulletInstance.direction = Vector2(0, 0)
		bulletInstance.position = self.position + Vector2(-14, 16)
	else:
		bulletInstance.direction = Vector2(1, 0)
		bulletInstance.position = self.position + Vector2(14, 16)
	get_parent().add_child(bulletInstance)

func move_timmy():
	currentState = STATE.MOVING
	var collision = self.move_and_collide(direction * SPEED)
	if (collision && collision.collider.is_in_group("enemies")):
		take_damage()

	# Check change in direction to update animation flip
	if direction.x == 1:
		animations.flip_h = true
	elif direction.x == -1:
		animations.flip_h = false

	animations.play()

func take_damage():
	hp -= 1
	if hp <= 0:
		currentState = STATE.DEAD
		var deathAnimation = load("res://assets/spriteFrames/timmy/timmyDeath.tres")
		animations.set_sprite_frames(deathAnimation)
		animations.set_animation("timmyDeath")

func _on_animations_animation_finished():
	if currentState == STATE.DEAD:
		animations.stop()
