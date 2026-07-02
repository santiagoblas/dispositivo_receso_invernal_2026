extends AnimatedSprite2D
class_name Coin


func _on_area_2d_body_entered(area):
	play("pop")


func _on_animation_finished():
	if animation == "pop":
		queue_free()
