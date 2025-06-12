extends Control

# VALUES =======================================================================
const COST = 1
const HEALTH_INCR = 100
const SPEED_INCR = 10
const DEFENSE_INCR = 2

@onready var speed_btn = $GridContainer/Speed
@onready var defense_btn = $GridContainer/Defense
@onready var health_btn = $GridContainer/Health
@onready var close_btn = $Close
@onready var coins_label = $VBoxContainer/CoinsLabel

func _ready() -> void:
	health_btn.pressed.connect(_on_health_pressed)
	speed_btn.pressed.connect(_on_speed_pressed)
	defense_btn.pressed.connect(_on_defense_pressed)
	close_btn.pressed.connect(_on_close_pressed)
	
	GameManager.connect("coins_changed", Callable(self, "_on_coins_changed"))
	_on_coins_changed(GameManager.coins)

func _on_coins_changed(current_coins) -> void:
	coins_label.text = "Coins: %d" % current_coins
	health_btn.disabled = current_coins < COST
	speed_btn.disabled = current_coins < COST
	defense_btn.disabled = current_coins < COST
	
func _on_health_pressed():
	_purchase_and_apply("health")
	
func _on_speed_pressed():
	_purchase_and_apply("speed")
	
func _on_defense_pressed():
	_purchase_and_apply("defense")
	
func _purchase_and_apply(stat):
	if GameManager.coins < COST:
		return
	GameManager.gain_coins(-COST)
	
	var stats = SaveManager.data.get("player_stats", {})
	match stat:
		"health":
			if GameManager.player != null:
				GameManager.player.max_health += HEALTH_INCR
				GameManager.player.health = GameManager.player.max_health
			stats["health"] = stats.get("health", 0) + HEALTH_INCR
		"speed":
			if GameManager.player != null:
				GameManager.player.speed += SPEED_INCR
			stats["speed"] = stats.get("speed", 0) + SPEED_INCR
		"defense":
			if GameManager.player != null:
				GameManager.player.defense += DEFENSE_INCR
			stats["defense"] = stats.get("defense", 0) + DEFENSE_INCR
		_:
			push_warning("Unknown purchase type: %s" % stat)
	
	SaveManager.data["player_stats"] = stats
	SaveManager.save_json()
	
func _on_close_pressed():
	queue_free()
