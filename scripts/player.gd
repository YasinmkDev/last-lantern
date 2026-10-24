extends CharacterBody2D
## Detective hero (assets/character/detective_*.png). Origin = feet.
## The art faces the camera, so left/right movement does not turn the
## sprite sideways; scale.x flipping mirrors only tiny asymmetries.
## Controls: move_left/move_right (A/D, arrows), jump (Space),
## crouch (S, Down), shoot (X). Touch controls will drive the same actions.

const SPEED = 300.0
const CROUCH_SPEED = 140.0
const JUMP_VELOCITY = -520.0
const COYOTE_TIME = 0.1
const JUMP_BUFFER = 0.1
const SHOOT_COOLDOWN = 0.25
const VISUAL_SCALE = 0.3

var coyote_timer = 0.0
var jump_buffer_timer = 0.0
var shoot_timer = 0.0
var spawn_position = Vector2.ZERO
var facing = 1
var crouching = false

func _ready():
	add_to_group("player")
	spawn_position = global_position
	$Visual.scale = Vector2(VISUAL_SCALE, VISUAL_SCALE)
	$Visual.play("idle")

func _physics_process(delta):
	# --- Crouch: only on the floor; stand up only when headroom is clear.
	if Input.is_action_pressed("crouch") and is_on_floor():
		_set_crouch(true)
	elif crouching and not test_move(global_transform, Vector2(0, -28)):
		_set_crouch(false)

	# --- Horizontal move (slower while crouched).
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * (CROUCH_SPEED if crouching else SPEED)
	if direction != 0:
		facing = sign(direction)
		$Visual.scale.x = facing * VISUAL_SCALE

	# --- Gravity + coyote time.
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		velocity.y += get_gravity().y * delta
		coyote_timer -= delta

	# --- Jump buffer.
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER
	else:
		jump_buffer_timer -= delta

	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		if crouching and test_move(global_transform, Vector2(0, -28)):
			pass # Headroom blocked: stay crouched, no jump this frame.
		else:
			if crouching:
				_set_crouch(false)
			velocity.y = JUMP_VELOCITY
			jump_buffer_timer = 0.0
			coyote_timer = 0.0

	# --- Shoot (cooldown so holding X doesn't machine-gun).
	shoot_timer -= delta
	if Input.is_action_just_pressed("shoot") and shoot_timer <= 0.0:
		shoot_timer = SHOOT_COOLDOWN
		var bullet = preload("res://scenes/bullet.tscn").instantiate()
		bullet.direction = facing
		bullet.global_position = global_position + Vector2(facing * 28, -18 if crouching else -32)
		get_parent().add_child(bullet)

	move_and_slide()

	# --- Animation: walk when moving, idle when still, stride pose in air.
	var anim = "jump" if not is_on_floor() else ("walk" if direction != 0 else "idle")
	if $Visual.animation != anim:
		$Visual.play(anim)

func _set_crouch(state: bool):
	if crouching == state:
		return
	crouching = state
	$StandShape.disabled = state
	$CrouchShape.disabled = not state
	# Visual squashes around the feet (Visual origin = player origin = feet).
	$Visual.scale.y = (0.5625 if state else 1.0) * VISUAL_SCALE

func die():
	# Placeholder death: respawn at spawn point. Replace with real
	# damage/health logic when monster assets and rules arrive.
	global_position = spawn_position
	velocity = Vector2.ZERO
	if crouching:
		_set_crouch(false)
