extends "res://Entity/EntityBase.gd"

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.25
const AIR_RESISTANCE = 0.02
const GRAVITY = 200
const JUMP_FORCE = 128
const FIRE_RATE = 10

const BULLET_PATH = preload('res://Fireball.tscn')

var motion = Vector2.ZERO
var count = 0

#onready var sprite = $Sprite
#onready var animationPlayer = $AnimationPlayer

#shoots a fireball
func shoot():
	
	var bullet = BULLET_PATH.instance()
	get_parent().add_child(bullet)
	bullet.position = $Node2D/ShootLocation.global_position
	bullet.look_at(get_global_mouse_position())
	
	bullet.velocity = get_global_mouse_position() - bullet.position

func handle_shoot():
	if Input.is_mouse_button_pressed(1):
		if count == 0:
			shoot()
		count = count+1
		if count >= FIRE_RATE:
			count = 0
	if Input.is_action_just_released("click"):
		count = 0
	$Node2D.look_at(get_global_mouse_position())

#func move(delta):
	

func _physics_process(delta):
	
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	handle_shoot()
	
	
	
	if x_input != 0:
		animPlayer.play("Run")
		motion.x += x_input * ACCELERATION *delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
	else:
		animPlayer.play("Stand")
	
	motion.y += GRAVITY * delta
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		animPlayer.play("Jump")
		
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y =  - JUMP_FORCE/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
	
	motion = move_and_slide(motion, Vector2.UP)
