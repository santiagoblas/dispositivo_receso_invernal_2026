extends Node
class_name Sight


var _in_sight:bool


func _process(delta):
	_in_sight = %SightRC.is_colliding()
