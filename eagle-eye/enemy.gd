extends RigidBody2D

var direction = Vector2()
var speed = 50
var max_health = 100
var damage = 20
var repulse = 1

onready var health = max_health

onready var player = get_parent().get_node('Player')

func _ready():
	$Health.max_value = max_health

func _process(delta):
	$Health.value = health
	if repulse < 1:
		repulse += 1
	direction = \
			(player.get_global_position() - \
			self.get_global_position()).normalized()
	position += direction * speed * delta * repulse

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		player.score += 10 + player.combo * 10
		if player.combo < 4:
			player.combo += 1
		queue_free()

func _on_Enemy_body_entered(body):
	if body.is_in_group('player'):
		body.take_damage(damage)
		repulse = -(speed/3)
