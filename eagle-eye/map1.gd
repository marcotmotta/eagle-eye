extends Node2D

var spawn_delay = 5

onready var enemy = preload('res://Enemy.tscn')
onready var spawn = preload('res://Spawn.tscn')

func _ready():
	randomize()

func _on_SpawnEnemy_timeout():
	var temp_position = Vector2(randi() % 1280, randi() % 720)
	var spawn_instance = spawn.instance()
	spawn_instance.position = temp_position
	add_child(spawn_instance)
	yield(get_tree().create_timer(2), "timeout")
	var enemy_instance = enemy.instance()
	enemy_instance.position = temp_position
	add_child(enemy_instance)
	$SpawnEnemy.wait_time = spawn_delay
	if spawn_delay > 2:
		spawn_delay -= 0.1
	else:
		spawn_delay = 2

func _on_Button_button_down():
	get_tree().reload_current_scene()
	var negation = not get_tree().paused
	get_tree().paused = negation
	$Pause/Control.visible = negation
