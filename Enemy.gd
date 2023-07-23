extends CharacterBody2D

var speed : int = 450
var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	_move(player, delta)
	
func _move(target, delta):
	var direction = (target.position - global_position).normalized()
	var desired_velocity = direction * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	
	if direction != Vector2.ZERO:
		var rotation_angle = direction.angle()
		rotation = rotation_angle
		
	move_and_slide()
