extends KinematicBody2D

var velocity = Vector2(0,0)
var speed = 200


func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	
	#for index in get_slide_count():
	#	var collision = get
	if collision_info != null:
		if collision_info.collider.is_in_group("world"):
			queue_free()
		elif collision_info.collider.is_in_group("player"):
			queue_free()
	
	#if collision_info != null:
	#	queue_free()
		#self.remove_from_group()
		#remove_child(self)
