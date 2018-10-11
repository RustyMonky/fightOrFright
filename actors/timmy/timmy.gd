extends KinematicBody2D

enum STATE { REST, MOVING, DEAD }

onready var animations = $animations
onready var animationPlayer = $animationPlayer
onready var collider = $collider
onready var invincibleTimer = $invincibleTimer

var currentState = STATE.REST
var direction = Vector2(0, 0)
var fear = 0
var hp = 4
var isInvincible = false

const SPEED = 2

func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	if currentState == STATE.DEAD:
		return

	if fear >= 100:
		hp = 0
		take_damage()

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
	if currentState == STATE.DEAD:
		return

	# Bullet functionality does not depend on MOVING or REST states
	if event.is_action_pressed("ui_select"):
		fire()

	if currentState == STATE.MOVING:
		if event.is_action_released("ui_up") || event.is_action_released("ui_down") || event.is_action_released("ui_left") || event.is_action_released("ui_right"):
			currentState = STATE.REST

func die():
	currentState = STATE.DEAD
	var deathAnimation = load("res://assets/spriteFrames/timmy/timmyDeath.tres")
	animations.set_sprite_frames(deathAnimation)
	animations.set_animation("timmyDeath")

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
	if self.global_position.y + 32 > 360 && self.direction.y == 1:
		self.direction.y = 0
	elif self.global_position.y - 32 < 0 && self.direction.y == -1:
		self.direction.y = 0

	if self.global_position.x - 16 < 0 && self.direction.x == -1:
		self.direction.x = 0
	elif self.global_position.x + 16 > 640 && self.direction.x == 1:
		self.direction.x = 0

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
	if isInvincible:
		return

	hp -= 1

	if hp <= 0:
		die()
	else:
		isInvincible = true
		collider.disabled = true
		invincibleTimer.start()
		animationPlayer.play("timmyDamaged")

func _on_animations_animation_finished():
	if currentState == STATE.DEAD:
		animations.stop()

func _on_invincibleTimer_timeout():
	isInvincible = false
	collider.disabled = false
	animationPlayer.stop()

func _on_fearRange_body_entered(body):
	if currentState == STATE.DEAD:
		return

	if body.is_in_group("enemies"):
		fear += 5
		print("Timmy's fear is " + String(fear))
