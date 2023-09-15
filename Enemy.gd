extends CharacterBody2D

class_name Enemy

@export var max_health : int = 1
var speed : int = 450
var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Enemy")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if player == null: player = get_tree().get_nodes_in_group("Player")[0]
	if player != null: _move(player, delta)
	
func _move(target, delta):
	var direction = (target.position - global_position).normalized()
	var desired_velocity = direction * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	
	if direction != Vector2.ZERO:
		var rotation_angle = direction.angle()
		rotation = rotation_angle
		
	move_and_slide()

func _take_damage() -> void:
	max_health -= 1
	if max_health == 0:
		queue_free()
