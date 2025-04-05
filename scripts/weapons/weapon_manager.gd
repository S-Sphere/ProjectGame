extends Node
class_name WeaponManager

# Para guardar as armas a que po jogador tem acesso
var weapons = []
var current_weapon_index = 0

func add_weapon(weapon) -> void:
	weapons.append(weapon)
	add_child(weapon)
	
func fire_all_weapons() -> void:
	for weapon in weapons:
		if weapon.has_method("fire"):
			weapon.fire()
