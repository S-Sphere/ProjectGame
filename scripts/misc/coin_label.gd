extends Label

@onready var coin_label = $"."



func _ready():
	GameManager.connect("coins_changed", Callable(self, "_on_coins_changed"))
	coin_label.text = "Coins: " + str(GameManager.coins)
	
func _on_coins_changed(current_coins):
	coin_label.text = "Coins: " + str(GameManager.coins)
