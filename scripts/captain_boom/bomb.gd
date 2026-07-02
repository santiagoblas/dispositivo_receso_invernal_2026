extends RigidBody2D
class_name Bomb


func _on_boom_timeout():
	_explode()


func _explode():
	$AnimatedSprite2D.queue_free()
	$AttackArea/CollisionShape2D.disabled = false
	$GPUParticles2D.emitting = true
	await get_tree().create_timer(.5).timeout
	$AttackArea/CollisionShape2D.disabled = true


func _on_gpu_particles_2d_finished():
	queue_free()
