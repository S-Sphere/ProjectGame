# GameManger.gd
extends Node

# Signals ======================================================================
signal xp_changed(current_xp, xp_cap)
signal coins_changed(current_coins)
signal run_coins_changed(current_run_coins)
signal health_changed(current_health, max_health)
signal kills_changed(current_kills)
# Exports ======================================================================
# @export var max_run_level = 10
@export var upgrade_scene: PackedScene = preload("res://scenes/ui/upgrade_seletion.tscn")
@export var end_screen_scene = preload("res://scenes/ui/end_screen.tscn")
@export var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")

@export var all_upgrades: Array[Resource] = [
	preload("res://data/upgrades/health_upgrade.tres"),
	preload("res://data/upgrades/damage_upgrade.tres"),
	preload("res://data/upgrades/speed_upgrade.tres"),
	preload("res://data/upgrades/magnet_upgrade.tres"),
	preload("res://data/upgrades/radial_weapon.tres"),
	preload("res://data/upgrades/firebolt_weapon.tres"),
	preload("res://data/upgrades/lightning_weapon.tres"),
	preload("res://data/upgrades/aura_weapon.tres")
]
# Variables =============================================
var xp = 0
var level = 1
var xp_to_next_level = 100
var player = null
var coins = 0
var run_coins = 0
# run stats
var kills = 0
var start_time = 0
func get_run_time() -> int:
	return int((Time.get_ticks_msec() - start_time) / 1000.0)

func format_time(secs) -> String:
	if secs < 60:
		return "%ds" % secs
	return "%d:%02d" % [secs / 60, secs % 60]

func get_run_time_string() -> String:
	return format_time(get_run_time())
	
func get_run_stats():
	var upgrade_texts = []
	for key in upgrade_levels.keys():
		var lvl = upgrade_levels[key]
		var name = key
		for upg in all_upgrades:
			var k = upg.stat
			if upg.weapon_scene:
				k += upg.weapon_scene.resource_path
			if k == key:
				name = upg.name
				break
		upgrade_texts.append("%s Lv %d" % [name, lvl])
		return {
			"coins": run_coins,
			"level": level,
			"kills": kills,
			"time": int((Time.get_ticks_msec() - start_time) / 1000.0),
			"upgrades": upgrade_texts
		}
# track upgrades
var upgrade_levels = {}

func _ready() -> void:
	SaveManager.load_json()
	coins = int(SaveManager.data.get("coins", 0))
	emit_signal("coins_changed", coins)

func register_player(player) -> void:
	self.player = player
	var stats = SaveManager.data.get("player_stats", {})
	if stats.has("health"):
		player.max_health += stats["health"]
		player.health = player.max_health
	if stats.has("speed"):
		player.movement_speed += stats["speed"]
	if stats.has("defense"):
		player.defense += stats["defense"]
	if stats.has("magnet"):
		player.magnet_range += stats["magnet"]
	start_run()

func heal_player(amount) -> void:
	if player:
		player.health = min(player.max_health, player.health + amount)
		emit_signal("health_changed", player.health, player.max_health)

func gain_experience(amount) -> void:
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
	upgrade_ui.popup(choices)
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
		"damage":
			player.dmg += amount
		"speed":
			player.movement_speed *= (1.0 + amount)
		"magnet":
			player.magnet_range += amount
		"fire_rate":
			for w in player.weapon_manager.weapons:
				w.cooldown = max(0.1, w.cooldown - amount)
		"weapon":
			if upgrade.weapon_scene:
				var scene_path = upgrade.weapon_scene.resource_path
				if lvl == 1:
					var new_weapon = upgrade.weapon_scene.instantiate()
					player.weapon_manager.add_weapon(new_weapon)
				else:
					for w in player.weapon_manager.weapons:
						if w.get_scene_file_path() == scene_path:
							w.level = lvl
							break
		_:
			push_warning("Unknown upgrade type: %s" % upgrade.stat)
	get_tree().paused = false

# coin methods -> persistent -> possibly going to a separate file
func gain_coins(amount) -> void:
	if player != null and amount > 0:
		run_coins += amount
		emit_signal("run_coins_changed", run_coins)
	else:
		coins += amount
		emit_signal("coins_changed", coins)
		SaveManager.data["coins"] = coins
		SaveManager.save_json()

func reset_run_coins() -> void:
	run_coins = 0
	emit_signal("run_coins_changed", run_coins)

func start_run() -> void:
	reset_run_coins()
	kills = 0
	start_time = Time.get_ticks_msec()
	xp = 0
	level = 0
	xp_to_next_level = 100
	emit_signal("xp_changed", xp, xp_to_next_level)

func incr_kills(amount = 1) -> void:
	kills += amount
	emit_signal("kills_changed, kills")

func end_run() -> void:
	var ui = get_tree().current_scene.get_node("UI")
	if ui == null:
		return
	
	var stats = get_run_stats()
	coins += run_coins
	emit_signal("coins_changed", coins)
	SaveManager.data["coins"] = coins
	SaveManager.save_json()
	var end_screen = end_screen_scene.instantiate()
	ui.add_child(end_screen)
	get_tree().paused = true
	end_screen.show_stats(stats)

func show_pause_menu() -> void:
	var ui = get_tree().current_scene.get_node("UI")
	if ui == null:
		return
	var pause_menu = pause_menu_scene.instantiate()
	ui.add_child(pause_menu)
	get_tree().paused = true
	pause_menu.show_stats(get_run_stats())

func _input(event) -> void:
	if player != null and event.is_action_pressed("ui_cancel") and not get_tree().paused:
		show_pause_menu()
