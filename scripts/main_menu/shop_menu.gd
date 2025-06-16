extends Control

# VALUES =======================================================================
const COST = 1
const HEALTH_INCR = 100
const SPEED_INCR = 10
const DEFENSE_INCR = 2
const MAGNET_INCR = 50
const MAX_LEVEL = 10
const UPGRADE_DATA = {
	"health"  : {"cost" : 10, "incr" : 100},
	"speed"   : {"cost" : 10, "incr" : 10},
	"defense" : {"cost" : 10, "incr" : 2},
	"magnet"  : {"cost" : 10, "incr" : 20},
} 

@onready var speed_btn = $GridContainer/Speed
@onready var defense_btn = $GridContainer/Defense
@onready var health_btn = $GridContainer/Health
@onready var magnet_btn = $GridContainer/Magnet
@onready var close_btn = $Close
@onready var coins_label = $VBoxContainer/CoinsLabel

func _ready() -> void:
	health_btn.pressed.connect(_on_health_pressed)
	speed_btn.pressed.connect(_on_speed_pressed)
	defense_btn.pressed.connect(_on_defense_pressed)
	magnet_btn.pressed.connect(_on_magnet_pressed)
	close_btn.pressed.connect(_on_close_pressed)
	
	GameManager.connect("coins_changed", Callable(self, "_on_coins_changed"))
	_update_button_texts()
	_on_coins_changed(GameManager.coins)

func _on_coins_changed(current_coins) -> void:
	coins_label.text = "Coins: %d" % current_coins
	var upgrades = SaveManager.data.get("upgrades", {})
	var health_lvl = upgrades.get("health", 0)
	var speed_lvl = upgrades.get("speed", 0)
	var defense_lvl = upgrades.get("defense", 0)
	var magnet_lvl = upgrades.get("magnet", 0)
	
	health_btn.disabled = current_coins < _next_cost("health", health_lvl) or health_lvl >= MAX_LEVEL
	speed_btn.disabled = current_coins < _next_cost("speed", speed_lvl) or speed_lvl >= MAX_LEVEL
	defense_btn.disabled = current_coins < _next_cost("defense", defense_lvl) or defense_lvl >= MAX_LEVEL
	magnet_btn.disabled = current_coins < _next_cost("magnet", magnet_lvl) or magnet_lvl >= MAX_LEVEL
	
func _on_health_pressed():
	_purchase_and_apply("health")
	
func _on_speed_pressed():
	_purchase_and_apply("speed")
	
func _on_defense_pressed():
	_purchase_and_apply("defense")

func _on_magnet_pressed() -> void:
	_purchase_and_apply("magnet")

func _purchase_and_apply(stat):
	var upgrades = SaveManager.data.get("upgrades", {})
	var lvl = upgrades.get(stat, 0)
	if lvl >= MAX_LEVEL:
		return
	var cost = _next_cost(stat, lvl)
	if GameManager.coins < cost:
		return
	GameManager.gain_coins(-cost)
	
	lvl += 1
	upgrades[stat] = lvl
	var stats = SaveManager.data.get("player_stats", {})
	match stat:
		"health":
			if GameManager.player != null:
				GameManager.player.max_health += UPGRADE_DATA["health"].incr
				GameManager.player.health = GameManager.player.max_health
			stats["health"] = stats.get("health", 0) + UPGRADE_DATA["health"].incr
		"speed":
			if GameManager.player != null:
				GameManager.player.movement_speed += UPGRADE_DATA["speed"].incr
			stats["speed"] = stats.get("speed", 0) + UPGRADE_DATA["speed"].incr
		"defense":
			if GameManager.player != null:
				GameManager.player.defense += UPGRADE_DATA["defense"].incr
			stats["defense"] = stats.get("defense", 0) + UPGRADE_DATA["defense"].incr
		"magnet":
			if GameManager.player != null:
				GameManager.player.magnet_range += UPGRADE_DATA["magnet"].incr
			stats["magnet"] = stats.get("magnet", 0) + UPGRADE_DATA["magnet"].incr
		_:
			push_warning("Unknown purchase type: %s" % stat)
	
	SaveManager.data["player_stats"] = stats
	SaveManager.data["upgrades"] = upgrades
	SaveManager.save_json()
	_update_button_texts()
	
func _on_close_pressed():
	queue_free()

func _update_button_texts() -> void:
	var upgrades = SaveManager.data.get("upgrades", {})
	var h_lvl = upgrades.get("health", 0)
	var s_lvl = upgrades.get("speed", 0)
	var d_lvl = upgrades.get("defense", 0)
	var m_lvl = upgrades.get("magnet", 0)
	
	health_btn.text = "Health Lv %d (Cost %d)" % [h_lvl, _next_cost("health", h_lvl)]
	speed_btn.text = "Speed Lv %d (Cost %d)" % [s_lvl, _next_cost("speed", s_lvl)]
	defense_btn.text = "Defense Lv %d (Cost %d)" % [d_lvl, _next_cost("defense", d_lvl)]
	magnet_btn.text = "Magnet Lv %d (Cost %d)" % [m_lvl, _next_cost("magnet", m_lvl)]

func _next_cost(stat, lvl) -> int:
	return UPGRADE_DATA[stat].cost * (lvl + 1)
