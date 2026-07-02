extends Node
class_name EnemyMovement


@export var SPEED = 30.0
const JUMP_VELOCITY = -400.0


@export var _enemy:Enemy
@export var _target:CaptainBoom
@export var _active:bool = true


@export var _direction:float


func _ready():
	if _direction > 0:
		_flip()


func _physics_process(delta):
	if not _enemy.is_on_floor():
		_enemy.velocity += _enemy.get_gravity() * delta
	
	if %Health._has_control or %Attack._has_control:
		return
	
	_movement()

	_enemy.move_and_slide()


func _movement():
	if not _active or _enemy._dead:
		return
	
	if $"../Sight"._in_sight:
		_follow()
	else:
		_patrol()
	
	%AnimationPlayer.play("walk")


func _patrol():
	if not %FloorRC.is_colliding():
		_flip()
		_direction = _direction * -1
	
	_enemy.velocity.x = _direction * SPEED


func _follow():
	if not %FloorRC.is_colliding():
		_enemy.velocity = Vector2.ZERO
		return
	
	_enemy.velocity.x = _direction * SPEED * 1.8


func _flip():
	$"../Sprite2D".flip_h = not $"../Sprite2D".flip_h
	$"../FlipComponents".scale.x *= -1
