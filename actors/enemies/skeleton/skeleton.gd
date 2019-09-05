extends KinematicBody2D

const SPEED = 8

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

enum STATE {ALIVE, FOLLOW, DEAD, TITLE}

onready var animations = $animations
onready var audio = $audio
onready var collider = $collider
onready var deathSound = load("res://assets/sounds/effects/skeletonDeath.wav")
onready var fadeTimer = $fadeTimer
onready var fadeTween = $fadeTween
onready var lightOccluder = $lightOccluder
onready var ray = $ray

var collision
var currentState = STATE.ALIVE
var deathAnimation = load("res://assets/spriteFrames/enemies/skeleton/skeletonDeath.tres")
var direction
var hp = 2
var tilemap
var timmy
var motion

var speed = SPEED * 4

func _ready():
	if !get_parent().has_node("navi"):
		currentState = STATE.TITLE
		speed = SPEED * 3
	else:
		tilemap = get_parent().get_node("navi").get_node("tilemap")
		timmy = get_parent().get_node("navi").get_node("timmy")
	animations.playing = true
	set_physics_process(true)

func _physics_process(delta):
	if currentState == STATE.DEAD:
		return
	elif currentState == STATE.TITLE:
		motion = self.direction.normalized() * speed * delta
	else:
		motion = util.cartesian_to_isometric(self.direction * speed * delta)

	if self.global_position.x > get_parent().get_viewport().size.x + 32:
		self.queue_free()

	if currentState == STATE.TITLE:
		collision = self.move_and_collide(motion)
	else:
#		var currentMapPosition = tilemap.world_to_map(self.global_position)
#		var timmyMapPosition = tilemap.world_to_map(timmy.global_position)
#
#		if currentMapPosition.x < timmyMapPosition.x:
#			self.direction = RIGHT
#		elif currentMapPosition.x > timmyMapPosition.x:
#			self.direction = LEFT
#
#		if self.direction != RIGHT && self.direction != LEFT:
#			if currentMapPosition.y < timmyMapPosition.y:
#				self.direction = DOWN
#			elif currentMapPosition.y > timmyMapPosition.y:
#				self.direction.y = UP
#
#		if animations.flip_h && self.direction == RIGHT:
#			animations.flip_h = false
#		elif !animations.flip_h && self.direction == LEFT:
#			animations.flip_h = true
#
#		#print("Direction", self.direction)
		motion = util.cartesian_to_isometric(self.direction.normalized() * speed * delta)
#		#print("Motion", motion)
#
		ray.set_cast_to(motion)
		if ray.is_colliding() && ray.get_collider().is_in_group("enemies"):
			return

		collision = self.move_and_collide(motion)

func move_to_timmy():
	currentState = STATE.FOLLOW

func take_damage():
	hp -= 1
	if hp == 0:
		self.remove_child(collider)
		self.remove_child(lightOccluder)
		self.z_index = -1
		get_parent().get_node("timmy").update_fear(-1)

		animations.set_sprite_frames(deathAnimation)
		animations.set_animation("skeletonDeath")
		currentState = STATE.DEAD

		gameData.mobsKilled += 1

		audio.set_stream(deathSound)
		audio.play()

func _on_animations_animation_finished():
	if currentState == STATE.DEAD:
		fadeTimer.start()

func _on_fadeTimer_timeout():
	fadeTween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	fadeTween.start()

func _on_fadeTween_tween_completed():
	self.queue_free()
