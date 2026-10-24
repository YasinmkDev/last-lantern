extends Camera2D
## Side-view camera: follows the player horizontally (left to right),
## vertical position stays fixed. This is the "camera moves with character"
## setup; tune follow_speed for tighter/looser feel.

@export var player_path: NodePath
@export var follow_speed = 5.0
@export var fixed_y = 360.0

var player: Node2D

func _ready():
	if player_path != NodePath(""):
		player = get_node(player_path)
	position = Vector2(640, fixed_y)

func _process(delta):
	if player:
		position.x = lerp(position.x, player.global_position.x, 1.0 - exp(-follow_speed * delta))
		position.y = fixed_y
