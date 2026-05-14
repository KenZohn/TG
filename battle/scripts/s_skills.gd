extends Node

func apply_s_health(current_hp, max_hp):
	return current_hp + max_hp * 0.05

func apply_s_time(max_hp):
	return max_hp * 0.25

func apply_s_damage(current_damage, base_damage):
	return current_damage + (base_damage * 0.05)

func apply_s_critical(current_crit_damage):
	return current_crit_damage * 2

func apply_s_defense():
	if randf() < 0.15:
		return true
	return false
