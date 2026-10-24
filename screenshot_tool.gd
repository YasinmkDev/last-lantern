extends SceneTree
## One-off tool: loads scenes/main.tscn, moves the player along the
## level, and saves one screenshot per screen to shots/shot_N.png.
## Run: xvfb-run -a godot --path . -s screenshot_tool.gd
## (NOT part of the game; nothing references this script.)

var shots := [640, 1930, 3220, 4510, 5800, 7090, 8380, 9670]
var idx := 0
var frames := 0
var main: Node

func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute("/home/hatch/workspace/tools/jtmp/last-lantern-shots")
	var packed: PackedScene = load("res://scenes/main.tscn")
	main = packed.instantiate()
	root.add_child(main)
	_move_to(shots[0])

func _move_to(x: float) -> void:
	var player = main.get_node("Player")
	player.position = Vector2(x, 600)
	var cam = main.get_node("Camera2D")
	cam.position = Vector2(x, 360)
	frames = 0

func _process(_delta: float) -> bool:
	frames += 1
	if frames < 90:
		return false
	var img: Image = root.get_texture().get_image()
	img.save_png("/home/hatch/workspace/tools/jtmp/last-lantern-shots/shot_%d.png" % idx)
	print("saved shot ", idx, " at x=", shots[idx])
	idx += 1
	if idx >= shots.size():
		quit()
		return true
	_move_to(shots[idx])
	return false
