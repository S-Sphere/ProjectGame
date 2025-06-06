extends Label

@onready var coin_label = $"."



func _ready():
	GameManager.connect("run_coins_changed", Callable(self, "_on_run_coins_changed"))
	coin_label.text = "Coins: " + str(GameManager.run_coins)
	
func _on_run_coins_changed(current_run_coins):
	coin_label.text = "Coins: " + str(current_run_coins)
