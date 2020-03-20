extends KinematicBody2D

export (int) var speed = 400
export (int) var damage = 10
export (float) var fire_rate = 0.2
export (int) var max_health = 100

onready var health = max_health

var bullet = preload("res://bullet.tscn")
var can_shoot = true
var score = 0
var velocity = Vector2()

var combos = ['x1', 'x2', 'x3', 'x4', 'x5']
var combo = 0

func _ready():
	$CanvasLayer/Health.max_value = max_health

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func _process(delta):
	$CanvasLayer/Health.value = health
	$CanvasLayer/Score.set_text(str(score))
	$CanvasLayer/Combo.set_text(combos[combo])
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("shoot") and can_shoot:
		var bullet_instance = bullet.instance()
		bullet_instance.damage = damage
		bullet_instance.position = $ShootPosition.get_global_position()
		bullet_instance.direction = \
			(bullet_instance.position - \
			$CenterPoint.get_global_position()).normalized()
		get_parent().add_child(bullet_instance)
		can_shoot = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_shoot = true

func take_damage(dmg):
	health -= dmg
	combo = 0
	if health <= 0:
		var negation = not get_tree().paused
		get_tree().paused = negation
		get_parent().get_node('Pause/Control').visible = negation
		get_parent().get_node('Pause/Control/VBoxContainer/Label').set_text('Score: ' + str(score))
