extends SceneTree
## One-off logic test: loads scenes/main.tscn, simulates key presses, and
## asserts move/jump/crouch/shoot behaviour. Run:
## godot --headless --path . -s test_player.gd
## (NOT part of the game.)

var main: Node
var player: Node
var frame := 0
var phase := 0
var start_x := 0.0
var results := []

func _initialize() -> void:
	var packed: PackedScene = load("res://scenes/main.tscn")
	main = packed.instantiate()
	root.add_child(main)
	player = main.get_node("Player")
	start_x = player.global_position.x
	print("start_x=", start_x)

func _check(name: String, ok: bool) -> void:
	results.append(name + ": " + ("PASS" if ok else "FAIL"))
	print(results[-1])

func _process(_delta: float) -> bool:
	frame += 1
	match phase:
		0: # settle on the floor, then hold move_right
			if frame > 10:
				Input.action_press("move_right")
				phase = 1
		1: # move right 60 frames
			if frame > 70:
				Input.action_release("move_right")
				_check("move_right increases x", player.global_position.x > start_x + 100)
				_check("facing right", player.facing == 1)
				_check("walk animation while moving", str(player.get_node("Visual").animation) == "walk")
				Input.action_press("move_left")
				phase = 2
		2: # move left 60 frames
			if frame > 130:
				Input.action_release("move_left")
				_check("move_left decreases x", player.global_position.x < start_x + 100)
				_check("facing left", player.facing == -1)
				phase = 3
		3: # wait for landing, then stand still a few frames
			if player.is_on_floor():
				phase = 30
				frame = 0
			elif frame > 400:
				_check("player on floor before jump", false)
				_finish()
				return true
		30: # idle check after the animation has had ticks to switch
			if frame > 5:
				_check("idle animation when still", str(player.get_node("Visual").animation) == "idle")
				Input.action_press("jump")
				phase = 4
		4:
			Input.action_release("jump")
			phase = 5
		5: # airborne check after 15 frames
			if frame > 0 and player.global_position.y < 595:
				_check("jump leaves ground", true)
				_check("jump animation in air", str(player.get_node("Visual").animation) == "jump")
				phase = 6
			elif frame > 300:
				_check("jump leaves ground", false)
				phase = 6
		6: # wait to land, then crouch
			if player.is_on_floor():
				Input.action_press("crouch")
				phase = 7
				frame = 0
			elif frame > 600:
				_check("lands after jump", false)
				_finish()
				return true
		7: # crouched after 20 frames
			if frame > 20:
				_check("crouch flag", player.crouching)
				_check("stand shape disabled while crouched", player.get_node("StandShape").disabled)
				_check("crouch shape enabled while crouched", not player.get_node("CrouchShape").disabled)
				# squash 0.5625 x base visual scale 0.3
				_check("visual squashed", abs(player.get_node("Visual").scale.y - 0.16875) < 0.01)
				Input.action_release("crouch")
				phase = 8
				frame = 0
		8: # stood back up after 20 frames
			if frame > 20:
				_check("stand up after release", not player.crouching)
				_check("stand shape re-enabled", not player.get_node("StandShape").disabled)
				# teleport near Monster1 (patrols 1400..1600), facing right
				player.global_position = Vector2(1300, 600)
				player.velocity = Vector2.ZERO
				player.facing = 1
				player.get_node("Visual").scale.x = 1
				Input.action_press("shoot")
				phase = 9
				frame = 0
		9:
			Input.action_release("shoot")
			phase = 10
			frame = 0
		10: # bullet exists after 5 frames
			if frame > 5:
				var found := false
				for c in main.get_children():
					if c.name == "Bullet":
						found = true
				_check("shoot spawns bullet", found)
				phase = 11
				frame = 0
		11: # bullet reaches Monster1 within 90 frames
			var m1 = main.get_node_or_null("Monster1")
			if m1 == null or not is_instance_valid(m1):
				_check("bullet kills monster", true)
				_finish()
				return true
			if frame > 90:
				_check("bullet kills monster", false)
				_finish()
				return true
	return false

func _finish() -> void:
	print("---- TEST SUMMARY ----")
	for r in results:
		print(r)
	quit()
