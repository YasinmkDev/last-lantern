extends Area2D
## Placeholder pickup item. Drawn as a gold circle (no texture).
## Swap for a real item sprite later (see assets/README_ASSETS.md).

signal collected

func _ready():
	add_to_group("coins")
	body_entered.connect(_on_body_entered)

func _draw():
	draw_circle(Vector2.ZERO, 14, Color(1, 0.85, 0.1))
	draw_circle(Vector2.ZERO, 8, Color(1, 0.95, 0.55))

func _on_body_entered(body):
	if body.is_in_group("player"):
		collected.emit()
		queue_free()
