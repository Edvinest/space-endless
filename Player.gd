extends CharacterBody2D
class_name Player

@export var speed : int = 500
@export var rotation_speed : float = 5
@onready var projectile_scene : PackedScene = preload("res://Projectile.tscn")
var health : int = 3
var can_fire : bool
var can_move : bool = true
var is_alive : bool
var rotation_direction : float = 0
var screen_size : Vector2
var collision_position : Vector2
var knockback_force : float = 500

var enemies : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	var start_position : Vector2 = Vector2(screen_size.x / 2, screen_size.y / 2)
	add_to_group("Player", true)
	_start(start_position)
	
func _start(pos: Vector2):
	position = pos
	is_alive = true
	show()
	$Area2D/CollisionShape2D.disabled = false

func _get_input():
	if can_move:
		rotation_direction = Input.get_axis("move_left", "move_right")
		velocity = transform.x * Input.get_axis("move_down", "move_up") * speed
	
func _fire():
	if can_fire:
		var projectile : Projectile = projectile_scene.instantiate()
		projectile.position = $ShootPosition.global_position
		projectile._set_direction(rotation)
		projectile.shot_from = self
		projectile.rotation = rotation
		get_parent().add_child(projectile)
	
		can_fire = false
		$FireTimer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("shoot"): _fire()
	enemies = get_tree().get_nodes_in_group("Enemy")
#	if rotation_direction > 0:
#		$AnimatedSprite2D.animation = "rotate_right"
#	elif rotation_direction < 0:
#		$AnimatedSprite2D.animation = "rotate_left"
#	else: $AnimatedSprite2D.animation = "default"

	$Path2D.global_position = global_position

func _physics_process(delta):
	if is_alive:
		_get_input()
		rotation += rotation_direction * rotation_speed * delta
		move_and_slide()

func _take_damage():
	health -= 1
	
	#check if player has any health left
	#if health > 0:
	#make player blink for a few seconds if they do
	#$AnimatedSprite2D.animation = "damaged"
	#disable collision for a few seconds if they do
	#$CollisionShape2D.disabled = true
	#push the player in the opposite direction
	
	if health == 0:
		hide()
		$Area2D/CollisionShape2D.disabled = true
		is_alive = false

func _on_fire_timer_timeout():
	can_fire = true


func _on_body_entered(body):
	if body is Enemy:
		var knockback_direction = global_position - body.global_position
		knockback_direction = knockback_direction.normalized()
		var knockback_impulse = knockback_direction * knockback_force
		
		velocity = knockback_impulse  # Knock back the player in the calculated direction
		
		if is_alive:
			for enemy in enemies:
				enemy.velocity = -body.velocity * 2
			can_move = false
			
		_take_damage()
		
		await(get_tree().create_timer(0.8)).timeout
		
		can_move = true
