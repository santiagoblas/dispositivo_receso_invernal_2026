extends Node
class_name CaptainAttack


const _PREPARE_BOMB_ANIMATION:String = "prepare_bomb"


@export var _CAPTAIN:CaptainBoom


var _has_control:bool = false
var _can_attack:bool = true
var _aim:Vector2 = Vector2.RIGHT


func _process(delta):
	if not _has_control and %Movement._direction != 0:
		_aim = Vector2.RIGHT * sign(%Movement._direction)


func _input(event):
	var animation:String
	var cooldown:float
	
	if not _can_attack:
		return
	
	if event.is_action_pressed("attack"):
		animation = "attack_1"
		cooldown = 0.7
	
	elif event.is_action_pressed("bomb_attack"):
		animation = _PREPARE_BOMB_ANIMATION
	elif event.is_action_released("bomb_attack"):
		animation = "attack_bomb"
		cooldown = 1
		_throw_bomb()
	
	if animation == "":
		return
	
	_has_control = true
	%AnimationPlayer.play(animation)
	%AnimationPlayer.animation_finished.connect(_on_animation_finished)
	if cooldown > 0:
		_can_attack = false
		$Cooldown.start(cooldown)


func _throw_bomb():
	const BOMB = preload("uid://00rnslxudlp7")
	var new_bomb:RigidBody2D = BOMB.instantiate()
	
	var aim:Vector2 = _aim + Vector2.UP * .6
	
	new_bomb.global_position = _CAPTAIN.global_position + aim * 10
	add_child(new_bomb)
	new_bomb.apply_central_impulse(aim * 220)


func _on_cooldown_timeout():
	_can_attack = true


func _on_animation_finished(animation_name:String):
	if animation_name == _PREPARE_BOMB_ANIMATION:
		return
	
	var direction:float = Input.get_axis("move_left", "move_right")
	if direction != 0:
		%Movement._direction = direction
	
	_has_control = false
	%AnimationPlayer.animation_finished.disconnect(_on_animation_finished)
