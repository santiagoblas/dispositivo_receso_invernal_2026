extends Node
class_name CaptainMovement


const MIN_SPEED:float = 10
const MAX_SPEED:float = 100.0
const JUMP_VELOCITY = -250.0


@export var _CAPTAIN:CaptainBoom
var _direction:float = 0
var _last_direction:float = 0
var _speed:float = 0
var _gravity:float = 10
var _jumping:bool = false
var _knockback_push:Vector2 = Vector2.ZERO


func _input(event:InputEvent):
	if (%Attack._has_control and _CAPTAIN.is_on_floor()) or %Health._has_control:
		_direction = 0
		return
	
	if event.is_action("move_left") or event.is_action("move_right"):
		_direction = Input.get_axis("move_left", "move_right")
		_last_direction = _direction
	
	if event.is_action_pressed("jump") and _CAPTAIN.is_on_floor():
		_jump()
	
	if event.is_action_pressed("move_down") and _CAPTAIN.is_on_floor():
		_jump_down()


func _physics_process(delta):
	if not _CAPTAIN.is_on_floor():
		_CAPTAIN.velocity.y += _gravity
	
	if _knockback_push != Vector2.ZERO:
		_CAPTAIN.velocity = _knockback_push
		_knockback_push = _knockback_push.move_toward(Vector2.ZERO,delta * 600)
		_CAPTAIN.move_and_slide()
		return
	
	_movement(delta)
	
	if _jumping and _CAPTAIN.velocity.y > 0:
		_CAPTAIN.set_collision_mask_value(_CAPTAIN.LAYER_PLATFORM, true)
		_jumping = false
	
	_CAPTAIN.move_and_slide()


func _movement(delta):
	if _CAPTAIN._dead:
		return
	
	if not _CAPTAIN.is_on_floor():
		if _speed != 0:
			_speed = move_toward(_speed, 0, delta * 300)
	
	if _direction == 0 and _CAPTAIN.is_on_floor():
		_speed = move_toward(_speed, 0, delta * 300)
		if abs(_speed) <= MIN_SPEED:
			_speed = 0
		_CAPTAIN.velocity.x = _speed
		return
	
	if abs(_speed) <= MAX_SPEED or \
	(abs(_speed) > MAX_SPEED and sign(_speed) != _direction): 
		_speed = move_toward(_speed, _direction * MAX_SPEED, delta * 300)
	
	_CAPTAIN.velocity.x = _speed


func _jump():
	_jumping = true
	_CAPTAIN.velocity.y += JUMP_VELOCITY
	$"../AnimationPlayer".play("jump")
	
	_CAPTAIN.set_collision_mask_value(_CAPTAIN.LAYER_PLATFORM, false)


func _jump_down():
	_CAPTAIN.set_collision_mask_value(_CAPTAIN.LAYER_PLATFORM, false)
	
	$"../AnimationPlayer".play("fall")
	
	await get_tree().create_timer(.3).timeout
	_CAPTAIN.set_collision_mask_value(_CAPTAIN.LAYER_PLATFORM, true)


func _knockback(from:Vector2):
	var direction:Vector2 = from.direction_to(_CAPTAIN.global_position)
	
	_speed = 0
	_knockback_push = direction * 200
