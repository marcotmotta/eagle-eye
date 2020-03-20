extends RigidBody2D

var direction = Vector2.RIGHT
var speed = 600
var damage

func _process(delta):
	position += direction * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group('enemies'):
		body.take_damage(damage)
	queue_free()
