extends Node
class_name Stats

var total_hits: int = 0
var total_misses: int = 0
var total_damage: int = 0
var time_taken: float = 0.0

func _init():
	reset()

func reset():
	total_hits = 0
	total_misses = 0
	total_damage = 0
	time_taken = 0.0

func register_hit(damage: int):
	total_hits += 1
	total_damage += damage

func register_miss():
	total_misses += 1

func get_summary():
	return {
		"hits": total_hits,
		"misses": total_misses,
		"total_damage": total_damage,
		"time_taken": time_taken,
		"accuracy": get_accuracy()
	}

func get_accuracy():
	var total_attempts = total_hits + total_misses
	if total_attempts == 0:
		return 0.0
	return (float(total_hits) / float(total_attempts)) * 100.0

func print_summary():
	print("RESUMO DO DESAFIO")
	print("Acertos: ", total_hits)
	print("Erros: ", total_misses)
	print("Dano Total: ", total_damage)
	print("Tempo: %.2fs" % time_taken)
	print("Precisão: %.1f%%" % get_accuracy())
