extends CharacterBody2D
signal hit

@export var speed : int = 500
@export var rotation_speed : float = 5
var can_fire : bool
var rotation_direction : float = 0
var screen_size : Vector2
var projectile_scene : PackedScene = preload("res://Projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	var start_position : Vector2 = Vector2(screen_size.x / 2, screen_size.y / 2)
	_start(start_position)
	
func _start(pos: Vector2):
	position = pos
	$CollisionShape2D.disabled = false

func _get_input():
	rotation_direction = Input.get_axis("move_left", "move_right")
	velocity = transform.x * Input.get_axis("move_down", "move_up") * speed
	
func _fire():
	if can_fire:
		var projectile = projectile_scene.instantiate()
		projectile.position = $ShootPosition.global_position
		projectile._set_direction(rotation)
		get_parent().add_child(projectile)
	
		can_fire = false
		$FireTimer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("shoot"): _fire()
	
#	if rotation_direction > 0:
#		$AnimatedSprite2D.animation = "rotate_right"
#	elif rotation_direction < 0:
#		$AnimatedSprite2D.animation = "rotate_left"
#	else: $AnimatedSprite2D.animation = "default"

	$Path2D.global_position = global_position

func _physics_process(delta):
	_get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()

func _on_Player_body_entered(body):
	#check if player has any health left
	#make player blink for a few seconds if they do
	emit_signal("hit")
	#disable collision for a few seconds if they do
	#push the player in the opposite direction
	$CollisionShape2D.set_deferred("disabled", true)


func _on_fire_timer_timeout():
	can_fire = true
