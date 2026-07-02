extends Node
class_name CaptainHealth


@export var _CAPTAIN:CaptainBoom
var _has_control:bool
var _hp = 10


func _take_damage(damage:int):
	_has_control = true
	
	%AnimationPlayer.play("hit")
	%AnimationPlayer.animation_finished.connect(_on_animation_finished)
	
	if _hp > 0:
		_hp -= damage
		_update_hearts()
	
	if _hp <= 0:
		_hp = 0
		_die()


func _die():
	_CAPTAIN._dead = true
	%AnimationPlayer.play("die")
	await %AnimationPlayer.animation_finished
	%Attack.queue_free()
	$"../DamageDetection".queue_free()
	$"../AttackArea".queue_free()
	%Movement.queue_free()


func _update_hearts():
	var hearts = %HeartsContainer.get_children()
	for i in range(hearts.size()):
		var heart:TextureRect = hearts.get(i)
		if i + 1 < _hp:
			heart.modulate = Color.WHITE
		else:
			heart.modulate = Color.BLACK


func _respawn():
	_CAPTAIN.global_position = _CAPTAIN._respawn_point.global_position


func _on_damage_detection_area_entered(area:Area2D):
	if area.get_collision_layer_value(11):
		_respawn()
	elif area.get_collision_layer_value(5):
		_handle_enemy_collision(area.global_position)


func _on_damage_detection_body_entered(body:PhysicsBody2D):
	if body.get_collision_layer_value(5) and body is Enemy:
		_handle_enemy_collision(body.global_position)


func _handle_enemy_collision(hit_position:Vector2):
	_take_damage(1)
	%Movement._knockback(hit_position)


func _on_animation_finished(animation_name):
	_has_control = false
	
	%AnimationPlayer.animation_finished.disconnect(_on_animation_finished)
