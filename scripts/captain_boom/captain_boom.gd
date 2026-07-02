extends CharacterBody2D
class_name CaptainBoom


const LAYER_PLATFORM:int = 9


static var _instance:CaptainBoom


@export var _respawn_point:Marker2D
var _dead:bool = false


func _enter_tree():
	if _instance != null:
		free()
	_instance = self


func _input(event:InputEvent):
	if _dead:
		return
	
	if %Attack._has_control or %Health._has_control:
		return
	
	if event.is_action("move_left") or event.is_action("move_right"):
		var direction = Input.get_axis("move_left", "move_right")
		if direction != 0:
			_flip(direction)
			if is_on_floor(): 
				$AnimationPlayer.play("walk")


func _process(delta):
	if _dead:
		return
	
	_idle_animations()


func _idle_animations():
	var is_on_floor:bool = is_on_floor()
	
	if %Attack._has_control or %Health._has_control:
		return
	
	if is_on_floor and velocity.x != 0:
		$AnimationPlayer.play("walk")
	
	if not is_on_floor and velocity.y > 0:
		$AnimationPlayer.play("fall")
	
	if is_on_floor and $Movement._speed < 50 and $Movement._direction == 0:
		$AnimationPlayer.play("idle")


func _flip(direction):
	$Sprite2D.flip_h = direction < 0
	$AttackArea.position.x = 21 if direction > 0 else -21
