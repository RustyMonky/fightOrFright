extends KinematicBody2D

enum STATE {ALIVE, ATTACK, FOLLOW, DEAD}

onready var animations = $animations
onready var collider = $collider
onready var fadeTimer = $fadeTimer
onready var fadeTween = $fadeTween
onready var ray = $ray
onready var timmy = get_parent().get_node("timmy")

var attackAnimation = load("res://assets/spriteFrames/enemies/skeleton/skeletonAttack.tres")
var currentState = STATE.ALIVE
var direction
var hp = 2
var walkAnimation = load("res://assets/spriteFrames/enemies/skeleton/skeletonWalk.tres")

const SPEED = 32

func _ready():
	animations.playing = true
	set_physics_process(true)
	set_process(true)

func _process(delta):
	if ray.is_colliding() && can_hit_timmy():
		if ray.get_collider().is_in_group("timmy"):
			attack()

func _physics_process(delta):
	if currentState == STATE.ALIVE:
		self.move_and_collide(self.direction.normalized() * SPEED * delta)
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

		self.move_and_collide(self.direction.normalized() * SPEED * delta)

func attack():
	currentState = STATE.ATTACK
	animations.set_sprite_frames(attackAnimation)
	animations.set_animation("skeletonAttack")
	timmy.take_damage()

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
		currentState = STATE.DEAD
		collider.disabled = true
		self.z_index = -1

		var deathAnimation = load("res://assets/spriteFrames/enemies/skeleton/skeletonDeath.tres")
		animations.set_sprite_frames(deathAnimation)
		animations.set_animation("skeletonDeath")

func _on_animations_animation_finished():
	if currentState == STATE.DEAD:
		fadeTimer.start()
	elif currentState == STATE.ATTACK:
		currentState = STATE.FOLLOW
		animations.set_sprite_frames(walkAnimation)
		animations.set_animation("skeletonMove")

func _on_fadeTimer_timeout():
	fadeTween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	fadeTween.start()

func _on_fadeTween_tween_completed(object, key):
	self.queue_free()
