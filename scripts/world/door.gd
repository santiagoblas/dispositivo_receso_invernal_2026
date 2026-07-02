extends AnimatedSprite2D
class_name Door


var _open:bool


func _on_detection_body_entered(body):
	var enemies:Array = get_tree().get_nodes_in_group("enemies")
	
	if not enemies.is_empty():
		$Label.visible = true
		return
	
	$Label.visible = false
	play("open")
	_open = true


func _on_detection_body_exited(body):
	$Label.visible = false
	if _open:
		play("close")
