# WeaponManager.gd
extends Node
class_name WeaponManager

# Para guardar as armas a que po jogador tem acesso
var weapons = []
var current_weapon_index = 0

func add_weapon(weapon) -> void:
	weapons.append(weapon)
	add_child(weapon)
	print("🛠 WeaponManager added:", weapon, " parent is ", weapon.get_parent())
	weapon.tree_exited.connect(Callable(self, "_on_weapon_removed").bind(weapon))

func _on_weapon_removed(weapon) -> void:
	weapons.erase(weapon)

func fire_all_weapons() -> void:
	for weapon in weapons:
		if weapon.has_method("fire"):
			weapon.fire()

func update_origins(origin) -> void:
	for w in weapons:
		if w.is_in_group("origin_weapon"):
			w.attack_origin = origin
