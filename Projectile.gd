extends Area2D

class_name Projectile

@export var speed: float = 550
var direction : Vector2
var shot_from : Node

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _set_direction(rotation: float):
	direction = Vector2(cos(rotation), sin(rotation)).normalized()

func _on_body_entered(body: Node2D) -> void:
	if body == shot_from: return
	if body is Enemy:
		var enemy : Enemy = body as Enemy
		enemy._take_damage()
		print("pog")
				
	queue_free()
	
func _on_screen_exited():
	queue_free()
