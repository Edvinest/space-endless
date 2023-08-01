extends Node

var enemy : PackedScene = preload("res://Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Player.velocity.length() > 0 && $EnemyTimer.is_stopped():
		$EnemyTimer.start()

func _on_enemy_timer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	$Player/Path2D/PathFollow2D.progress = rng.randi_range(0, 3664)
	var enemyInstance = enemy.instantiate()
	enemyInstance.global_position = $Player/Path2D/PathFollow2D/Marker2D.global_position
	add_child(enemyInstance)
