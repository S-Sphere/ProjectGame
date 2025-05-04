# GameManger.gd
extends Node

@export var upgrade_scene: PackedScene = preload("res://scenes/ui/upgrade_seletion.tscn")
@export var all_upgrades: Array[Resource] = [
	preload("res://data/upgrades/health_upgrade.tres"),
	preload("res://data/upgrades/damage_upgrade.tres"),
	preload("res://data/upgrades/speed_upgrade.tres"),
	preload("res://data/upgrades/radial_weapon.tres"),
	preload("res://data/upgrades/firebolt_weapon.tres")
]

var xp = 0
var level = 1
var xp_to_next_level = 100
var player = null
# track upgrades
var upgrade_levels = {}

func register_player(player) -> void:
	self.player = player

func gain_experience(amount) -> void:
	xp += amount
	if xp >= xp_to_next_level:
		level_up()
	
func level_up() -> void:
	level += 1
	xp -= xp_to_next_level
	xp_to_next_level = int(xp_to_next_level) * 1.2
	show_upgrade_selection() # to shwo updates
	
func show_upgrade_selection() -> void:
	var choices = []
	for upg in all_upgrades:
		var key = upg.type
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
	var key = chosen.type + (chosen.weapon_scene.resource_path if chosen.weapon_scene != null else "")
	var lvl = upgrade_levels.get(key, 0)
	if lvl >= chosen.max_level:
		return
	
	lvl += 1
	upgrade_levels[key] = lvl
	_apply_upgrade(chosen, lvl)
	get_tree().paused = false

func _apply_upgrade(upgrade, lvl) -> void:
	var amount = upgrade.amount_for(lvl)
	match upgrade.type:
		"health":
			player.max_health += amount
			player.health     += amount
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
			push_warning("Unknown upgrade type: %s" % upgrade.type)
	get_tree().paused = false
