extends Control

# VALUES =======================================================================
const COST = 1
const HEALTH_INCR = 100
const SPEED_INCR = 10
const DEFENSE_INCR = 2

@onready var speed_btn = $Speed
@onready var defense_btn = $Defense
@onready var health_btn = $Health
@onready var close_btn = $Close
@onready var coins_label = $CoinsLabel

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
	
	match stat:
		"health":
			GameManager.player.max_health += HEALTH_INCR
		"speed":
			GameManager.player.speed += SPEED_INCR
		"defense":
			GameManager.player.defense += DEFENSE_INCR
		_:
			push_warning("Unknown purchase type: %s" % stat)
	
func _on_close_pressed():
	queue_free()
