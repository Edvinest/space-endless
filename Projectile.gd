extends Area2D

@export var speed: float = 550
var direction : Vector2

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _set_direction(rotation: float):
	direction = Vector2(cos(rotation), sin(rotation)).normalized()

func _on_body_entered(body: PhysicsBody2D) -> void:
	queue_free()
	
func _on_screen_exited():
	queue_free()
