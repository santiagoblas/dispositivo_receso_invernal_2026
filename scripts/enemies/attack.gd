extends Node
class_name EnemyAttack


@export var _ENEMY:Enemy
var _in_range:bool
var _can_attack:bool = true
var _has_control:bool = false


func _process(delta):
	if _ENEMY._dead:
		return
	
	_calculate_range()
	
	if not _in_range or not _can_attack:
		return
	
	_attack()


func _calculate_range():
	if not %Sight._in_sight:
		_in_range = false
		return
	
	_in_range = %RangeRC.is_colliding()


func _attack():
	_has_control = true
	_can_attack = false
	$CD.start()
	
	%AnimationPlayer.play("attack")
	await %AnimationPlayer.animation_finished
	_has_control = false
	if _ENEMY._dead:
		return
	%AnimationPlayer.play("idle")


func _on_cd_timeout():
	_can_attack = true
