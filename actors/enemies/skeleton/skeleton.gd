extends KinematicBody2D

const SPEED = 8

enum STATE {ALIVE, FOLLOW, DEAD, TITLE}

onready var animations = $animations
onready var audio = $audio
onready var collider = $collider
onready var deathSound = load("res://assets/sounds/effects/skeletonDeath.wav")
onready var fadeTimer = $fadeTimer
onready var fadeTween = $fadeTween
onready var lightOccluder = $lightOccluder

var currentState = STATE.ALIVE
var deathAnimation = load("res://assets/spriteFrames/enemies/skeleton/skeletonDeath.tres")
var direction
var hp = 2
var timmy
var motion

var speed = SPEED * 4

func _ready():
	if !get_parent().has_node("timmy"):
		currentState = STATE.TITLE
		speed = SPEED * 3
	else:
		timmy = get_parent().get_node("navi").get_node("timmy")
	animations.playing = true
	set_physics_process(true)

func _physics_process(delta):
	if currentState == STATE.TITLE:
		motion = self.direction.normalized() * speed * delta
	else:
		motion = util.cartesian_to_isometric(self.direction.normalized() * speed * delta)

	if self.global_position.x > get_parent().get_viewport().size.x + 32:
		self.queue_free()

	if currentState == STATE.ALIVE || currentState == STATE.TITLE:
		self.move_and_collide(motion)
	elif currentState == STATE.FOLLOW:
		if self.global_position.y < timmy.position.y:
			self.direction.y = 1
		elif self.global_position.y > timmy.position.y:
			self.direction.y = -1
		elif self.global_position.y == timmy.position.y:
			self.direction.y = 0

		if animations.flip_h && timmy.position.x > self.position.x:
			animations.flip_h = false
			self.direction.x = 1
		elif !animations.flip_h && timmy.position.x < self.position.x:
			animations.flip_h = true
			self.direction.x = -1

		self.move_and_collide(motion)

func can_hit_timmy():
	if animations.flip_h:
		return timmy.position.x - self.position.x <= 32
	else:
		return self.position.x - timmy.position.x <= 32

func move_to_timmy():
	currentState = STATE.FOLLOW

func take_damage():
	hp -= 1
	if hp == 0:
		self.remove_child(collider)
		self.remove_child(lightOccluder)
		self.z_index = -1
		if timmy.fear > 0:
			timmy.update_fear(-1)

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
