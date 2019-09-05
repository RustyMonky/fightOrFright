extends KinematicBody2D

const SPEED = 50

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

enum STATE { REST, MOVING, DEAD }

onready var animations = $animations
onready var animationPlayer = $animationPlayer
onready var audio = $audio
onready var collider = $collider
onready var invincibleTimer = $invincibleTimer
onready var light = $light
onready var lightTween = $lightTween
onready var pistolSound = load("res://assets/sounds/effects/pistol.wav")
onready var tilemap = get_parent().get_node("tilemap") # Assumes is child of a Navigational2D that contains a tilemap

var collision
var currentCell
var currentState = STATE.REST
var direction = Vector2(0, 0)
var fear = 0
var isInvincible = false
var motion
var nextCell

func _ready():
	set_process(true)
	set_process_input(true)

	# Center Timmy upon spawn in the middle of the tilemap
	self.global_position = tilemap.map_to_world(Vector2(8, 1))

func _process(delta):
	if currentState == STATE.DEAD:
		return

	if fear >= 100:
		die()

	if Input.is_action_pressed("ui_up"):
		self.direction = UP
		move_timmy(delta)

	elif Input.is_action_pressed("ui_down"):
		self.direction = DOWN
		move_timmy(delta)

	elif Input.is_action_pressed("ui_left"):
		self.direction = LEFT
		move_timmy(delta)

	elif Input.is_action_pressed("ui_right"):
		self.direction = RIGHT
		move_timmy(delta)


	if currentState == STATE.REST:
		if animations.is_playing():
			animations.stop()
			animations.set_frame(0)

func _input(event):
	if currentState == STATE.DEAD:
		return

	if fear >= 100:
		die()

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
		bulletInstance.position = self.position + Vector2(-14, -16)
	else:
		bulletInstance.position = self.position + Vector2(14, -16)

	bulletInstance.direction = self.direction
	get_parent().add_child(bulletInstance)

	audio.set_stream(pistolSound)
	audio.play()

func move_timmy(delta):
	currentState = STATE.MOVING

	# Determines direction of movement according to isometric perspective
	motion = util.cartesian_to_isometric(direction * SPEED * delta)

	# Determines if the tile map is using the destination cell before processing movement
	currentCell = tilemap.world_to_map(self.global_position)
	nextCell = tilemap.world_to_map(self.global_position + motion)
	if !tilemap.get_used_cells().has(nextCell):
		return

	collision = self.move_and_collide(motion)
	if (collision && collision.collider.is_in_group("enemies")):
		take_damage()

	# Check change in direction to update animation flip
	if direction.x == 1 || direction.y == -1:
		animations.flip_h = true
	elif direction.x == -1 || direction.y == 1:
		animations.flip_h = false

	animations.play()

func take_damage():
	if isInvincible || currentState == STATE.DEAD:
		return

	update_fear(25)

	if fear >= 100:
		die()
	else:
		isInvincible = true
		collider.disabled = true
		invincibleTimer.start()
		animationPlayer.play("timmyDamaged")

func update_fear(changeInt):
	fear += changeInt

	var newScale = 1 - abs(float(fear * 0.01))
	if newScale > 1:
		if !light.enabled:
			light.enabled = true
		newScale = 1
	elif newScale <= 0:
		light.enabled = false

	if light.enabled:
		lightTween.interpolate_property(light, "texture_scale", light.texture_scale, newScale, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		lightTween.start()

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
		update_fear(5)
