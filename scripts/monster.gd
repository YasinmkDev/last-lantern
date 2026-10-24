extends CharacterBody2D
## Placeholder monster: patrols left/right. Swap the Visual ColorRects for
## real monster sprites later (see assets/README_ASSETS.md).
## Touching the player sends the player back to spawn (see player.die).

@export var patrol_range = 100.0
@export var speed = 60.0

var start_x = 0.0
var direction = 1

func _ready():
	add_to_group("monsters")
	start_x = global_position.x
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(delta):
	velocity.x = direction * speed
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	move_and_slide()
	if global_position.x > start_x + patrol_range:
		direction = -1
	elif global_position.x < start_x - patrol_range:
		direction = 1
	if direction != 0:
		$Visual.scale.x = direction

func _on_hitbox_body_entered(body):
	if body.is_in_group("player") and body.has_method("die"):
		body.die()

func take_hit():
	# Shot by the player: removed. Replace with health/flash logic
	# when real monster rules arrive.
	queue_free()
