extends Node2D
## Level wiring: coin counter HUD + goal message.
## No gameplay rules live here; player/monster/coin scripts own their logic.

var coins = 0

func _ready():
	for coin in get_tree().get_nodes_in_group("coins"):
		coin.collected.connect(_on_coin_collected)
	$Goal.body_entered.connect(_on_goal_body_entered)

func _on_coin_collected():
	coins += 1
	$HUD/CoinsLabel.text = "Coins: %d" % coins

func _on_goal_body_entered(body):
	if body.is_in_group("player"):
		$HUD/StatusLabel.text = "Level Complete!"
		$HUD/StatusLabel.visible = true
