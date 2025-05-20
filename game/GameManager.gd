# GameManger.gd
extends Node

# Signals ======================================================================
signal xp_changed(current_xp, xp_cap)
signal coins_changed(current_coins)
signal health_changed(current_health, max_health)

# Exports ======================================================================
@export var max_run_level = 10
@export var upgrade_scene: PackedScene = preload("res://scenes/ui/upgrade_seletion.tscn")
@export var all_upgrades: Array[Resource] = [
	preload("res://data/upgrades/health_upgrade.tres"),
	preload("res://data/upgrades/damage_upgrade.tres"),
	preload("res://data/upgrades/speed_upgrade.tres"),
	preload("res://data/upgrades/radial_weapon.tres"),
	preload("res://data/upgrades/firebolt_weapon.tres"),
	preload("res://data/upgrades/lightning_weapon.tres")
]

var xp = 0
var level = 1
var xp_to_next_level = 100
var player = null
var coins = 0

# track upgrades
var upgrade_levels = {}

func _ready() -> void:
	load_persistent_coins()

func register_player(player) -> void:
	self.player = player

func heal_player(amount) -> void:
	if player:
		player.health = min(player.max_health, player.health + amount)
		emit_signal("health_changed", player.health, player.max_health)

func gain_experience(amount) -> void:
	if level >= max_run_level:
		return
	xp += amount
	emit_signal("xp_changed", xp, xp_to_next_level) #for the bar
	if xp >= xp_to_next_level:
		level_up()
	
func level_up() -> void:
	level += 1
	xp -= xp_to_next_level
	xp_to_next_level = int(xp_to_next_level) * 1.2
	emit_signal("xp_changed", xp, xp_to_next_level) #for the bar
	show_upgrade_selection() # to shwo updates
	
func show_upgrade_selection() -> void:
	var choices = []
	for upg in all_upgrades:
		var key = upg.stat
		if upg.weapon_scene:
			key += upg.weapon_scene.resource_path
		var lvl = upgrade_levels.get(key,0)
		if lvl < upg.max_level:
			choices.append(upg)
	if choices.is_empty():
		get_tree().paused = false
		return
	
	var upgrade_ui = upgrade_scene.instantiate()
	get_tree().current_scene.get_node("UI").add_child(upgrade_ui)
	get_tree().paused = true
	upgrade_ui.popup(all_upgrades)
	upgrade_ui.upgrade_chosen.connect(Callable(self, "_on_upgrade_chosen"))

func _on_upgrade_chosen(chosen) -> void:
	print("🎁 Upgrade chosen:", chosen.name)
	var key = chosen.stat + (chosen.weapon_scene.resource_path if chosen.weapon_scene != null else "")
	var lvl = upgrade_levels.get(key, 0)
	if lvl >= chosen.max_level:
		return
	
	lvl += 1
	upgrade_levels[key] = lvl
	print("   → New level for", chosen.name, "=", lvl)
	_apply_upgrade(chosen, lvl)
	get_tree().paused = false

func _apply_upgrade(upgrade, lvl) -> void:
	print("⚙️ Applying upgrade:", upgrade.name, "level", lvl)
	var amount = upgrade.amount_for(lvl)
	match upgrade.stat:
		"health":
			player.max_health += amount
			#player.health     += amount
		"damage":
			player.dmg += amount
		"speed":
			player.movement_speed *= (1.0 + amount)
		"fire_rate":
			for w in player.weapon_manager.weapons:
				w.cooldown = max(0.1, w.cooldown - amount)
		"weapon":
			if upgrade.weapon_scene:
				if lvl == 1 and upgrade.weapon_scene:
					var w = upgrade.weapon_scene.instantiate()
					player.weapon_manager.add_weapon(w)
		_:
			push_warning("Unknown upgrade type: %s" % upgrade.stat)
	get_tree().paused = false


# coin methods -> persistent -> possibly going to a separate file
func gain_coins(amount) -> void:
	coins += amount
	emit_signal("coins_changed", coins)
	save_persistent_coins()

func save_persistent_coins() -> void:
	var file = FileAccess.open("user://coins.save", FileAccess.ModeFlags.WRITE)
	if file:
		file.store_32(coins)
		file.close()

func load_persistent_coins() -> void:
	var file = FileAccess.open("user://coins.save", FileAccess.ModeFlags.READ)
	if file:
		coins = file.get_32()
		file.close()
	emit_signal("coins_changed", coins)
