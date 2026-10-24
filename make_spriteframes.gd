extends SceneTree
## One-off tool: builds the detective SpriteFrames resource from the sliced
## frames in assets/character/. Run AFTER the editor has imported the PNGs:
## godot --headless --path . -s make_spriteframes.gd
## (NOT part of the game.)

func _initialize() -> void:
	var frames = SpriteFrames.new()
	frames.add_animation("idle")
	frames.set_animation_loop("idle", true)
	frames.set_animation_speed("idle", 1.0)
	frames.add_frame("idle", load("res://assets/character/detective_idle.png"))
	frames.add_animation("walk")
	frames.set_animation_loop("walk", true)
	frames.set_animation_speed("walk", 10.0)
	for i in range(1, 9):
		frames.add_frame("walk", load("res://assets/character/detective_walk%d.png" % i))
	frames.add_animation("jump")
	frames.set_animation_loop("jump", true)
	frames.add_frame("jump", load("res://assets/character/detective_walk4.png"))
	ResourceSaver.save(frames, "res://assets/character/detective_spriteframes.tres")
	print("spriteframes saved")
	quit()
