extends Node

var enemy : PackedScene = preload("res://Enemy.tscn")
var PLAYER : Node
var ENEMYTIMER : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	PLAYER = get_node("/root/Main/Player")
	ENEMYTIMER = get_node("/root/Main/EnemyTimer")
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if PLAYER.velocity.length() > 0 && ENEMYTIMER.is_stopped():
		ENEMYTIMER.start()

func _on_enemy_timer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	#PLAYER/Path2D/PathFollow2D.progress = rng.randi_range(0, 3664)
	var enemyInstance = enemy.instantiate()
	enemyInstance.global_position = $Player/Path2D/PathFollow2D/Marker2D.global_position
	add_child(enemyInstance)
