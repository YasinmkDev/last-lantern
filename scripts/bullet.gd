extends Area2D
## Player bullet: flies straight in `direction`, dies on range end or on
## hitting a wall/ground/monster. Monsters hit by a bullet are removed
## (see monster.take_hit).

const SPEED = 700.0
const RANGE = 900.0

var direction = 1
var traveled = 0.0

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	var step = direction * SPEED * delta
	position.x += step
	traveled += abs(step)
	if traveled >= RANGE:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		return # Never hurt the shooter.
	if body.is_in_group("monsters") and body.has_method("take_hit"):
		body.take_hit()
		queue_free()
	elif body is StaticBody2D:
		queue_free() # Walls, platforms, ground.
