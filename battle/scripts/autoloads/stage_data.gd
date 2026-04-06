extends Node

var stages = {
	"W01-1": {
		"games": ["m1"],
		"skill_points": 1,
		"background": "green_field",
		"description": "A famosa fase 1",
		"enemy": "slime",
		"enemy_hp": 50,
		"enemy_damage": 8
	},
	"W01-2": {
		"games": ["a1"],
		"skill_points": 1,
		"background": "green_field",
		"enemy": "slime",
		"enemy_hp": 50,
		"enemy_damage": 8
	},
	"W01-3": {
		"games": ["f1"],
		"skill_points": 1,
		"background": "green_field",
		"enemy": "zombie",
		"enemy_hp": 55,
		"enemy_damage": 9
	},
	"W01-4": {
		"games": ["c1"],
		"skill_points": 1,
		"background": "green_field",
		"enemy": "zombie",
		"enemy_hp": 55,
		"enemy_damage": 9
	},
	"W01-5": {
		"games": ["r1"],
		"skill_points": 1,
		"background": "green_field",
		"enemy": "goblin",
		"enemy_hp": 60,
		"enemy_damage": 10
	},
	"W01-X": {
		"games": ["m1", "a1", "f1", "c1", "r1"],
		"skill_points": 3,
		"background": "green_field",
		"enemy": "goblin",
		"enemy_hp": 80,
		"enemy_damage": 10
	},
	"W02-1": {
		"games": ["c1", "r1"],
		"skill_points": 1,
		"background": "autumn_forest",
		"enemy": "slime",
		"enemy_hp": 65,
		"enemy_damage": 10
	},
	"W02-2": {
		"games": ["m1", "c1"],
		"skill_points": 1,
		"background": "autumn_forest",
		"enemy": "slime",
		"enemy_hp": 65,
		"enemy_damage": 10
	},
	"W02-3": {
		"games": ["m1", "f1"],
		"skill_points": 1,
		"background": "autumn_forest",
		"enemy": "zombie",
		"enemy_hp": 70,
		"enemy_damage": 12
	},
	"W02-4": {
		"games": ["f1", "r1"],
		"skill_points": 1,
		"background": "autumn_forest",
		"enemy": "zombie",
		"enemy_hp": 70,
		"enemy_damage": 12
	},
	"W02-5": {
		"games": ["f1", "c1"],
		"skill_points": 1,
		"background": "autumn_forest",
		"enemy": "goblin",
		"enemy_hp": 75,
		"enemy_damage": 14
	},
	"W02-I": {
		"games": ["f1"],
		"skill_points": 0,
		"background": "autumn_forest",
		"enemy": "goblin",
		"enemy_hp": 75,
		"enemy_damage": 14
	},
	"W02-X": {
		"games": ["m1", "a1", "f1", "c1", "r1"],
		"skill_points": 3,
		"background": "autumn_forest",
		"enemy": "goblin",
		"enemy_hp": 100,
		"enemy_damage": 15
	},
	"W03-1": {
		"games": ["m1", "r1"],
		"skill_points": 1,
		"background": "desert",
		"enemy": "slime",
		"enemy_hp": 70,
		"enemy_damage": 12
	},
	"W03-2": {
		"games": ["m1", "a1"],
		"skill_points": 1,
		"background": "desert",
		"enemy": "slime",
		"enemy_hp": 70,
		"enemy_damage": 12
	},
	"W03-3": {
		"games": ["a1", "f1"],
		"enemy": "zombie",
		"background": "desert",
		"skill_points": 1
	},
	"W03-4": {
		"games": ["a1", "c1"],
		"enemy": "zombie",
		"background": "desert",
		"skill_points": 1
	},
	"W03-5": {
		"games": ["a1", "r1"],
		"enemy": "goblin",
		"background": "desert",
		"skill_points": 1
	},
	"W03-I": {
		"games": ["a1"],
		"enemy": "goblin",
		"background": "desert",
		"skill_points": 0
	},
	"W03-X": {
		"games": ["m1", "a1", "f1", "c1", "r1"],
		"enemy": "goblin",
		"background": "desert",
		"skill_points": 3
	},
	"W04-1": {
		"games": ["m1", "a1", "f1"],
		"enemy": "slime",
		"background": "forest",
		"skill_points": 1
	},
	"W04-2": {
		"games": ["f1", "c1", "r1"],
		"enemy": "slime",
		"background": "forest",
		"skill_points": 1
	},
	"W04-3": {
		"games": ["m1", "a1", "r1"],
		"enemy": "zombie",
		"background": "forest",
		"skill_points": 1
	},
	"W04-4": {
		"games": ["m1", "f1", "r1"],
		"enemy": "zombie",
		"background": "forest",
		"skill_points": 1
	},
	"W04-5": {
		"games": ["a1", "f1", "r1"],
		"enemy": "goblin",
		"background": "forest",
		"skill_points": 1
	},
	"W04-I": {
		"games": ["r1"],
		"enemy": "goblin",
		"background": "forest",
		"skill_points": 0
	},
	"W04-X": {
		"games": ["m1", "a1", "f1", "c1", "r1"],
		"enemy": "goblin",
		"background": "forest",
		"skill_points": 3
	},
	"W05-1": {
		"games": ["m1", "a1", "c1"],
		"enemy": "slime",
		"background": "winter",
		"skill_points": 1
	},
	"W05-2": {
		"games": ["m1", "f1", "c1"],
		"enemy": "slime",
		"background": "winter",
		"skill_points": 1
	},
	"W05-3": {
		"games": ["m1", "c1", "r1"],
		"enemy": "zombie",
		"background": "winter",
		"skill_points": 1
	},
	"W05-4": {
		"games": ["a1", "f1", "c1"],
		"enemy": "zombie",
		"background": "winter",
		"skill_points": 1
	},
	"W05-5": {
		"games": ["a1", "c1", "r1"],
		"enemy": "goblin",
		"background": "winter",
		"skill_points": 1
	},
	"W05-I": {
		"games": ["c1"],
		"enemy": "goblin",
		"background": "winter",
		"skill_points": 0
	},
	"W05-X": {
		"games": ["m1", "a1", "f1", "c1", "r1"],
		"enemy": "goblin",
		"background": "winter",
		"skill_points": 3
	},
	"W06-1": {
		"games": ["m1", "a1", "f1", "c1"],
		"enemy": "slime",
		"background": "green_field",
		"skill_points": 1
	},
	"W06-2": {
		"games": ["m1", "a1", "f1", "r1"],
		"enemy": "slime",
		"background": "green_field",
		"skill_points": 1
	},
	"W06-3": {
		"games": ["m1", "a1", "c1", "r1"],
		"enemy": "zombie",
		"background": "green_field",
		"skill_points": 1
	},
	"W06-4": {
		"games": ["m1", "f1", "c1", "r1"],
		"enemy": "zombie",
		"background": "green_field",
		"skill_points": 1
	},
	"W06-5": {
		"games": ["a1", "f1", "c1", "r1"],
		"enemy": "goblin",
		"background": "green_field",
		"skill_points": 1
	},
	"W06-I": {
		"games": ["m1", "a1", "f1", "c1", "r1"],
		"enemy": "goblin",
		"background": "green_field",
		"skill_points": 0
	},
	"W06-X": {
		"games": ["m1", "a1", "f1", "c1", "r1"],
		"enemy": "goblin",
		"background": "green_field",
		"skill_points": 5
	},
	"W07-1": {
		"games": ["r1",
				  "r2"],
		"enemy": "slime",
		"background": "green_field",
		"skill_points": 1
	},
	"W07-2": {
		"games": ["c1",
				  "c2"],
		"enemy": "slime",
		"background": "green_field",
		"skill_points": 1
	},
	"W07-3": {
		"games": ["f1",
				  "f2"],
		"enemy": "zombie",
		"background": "green_field",
		"skill_points": 1
	},
	"W07-4": {
		"games": ["a1",
				  "a2"],
		"enemy": "zombie",
		"background": "green_field",
		"skill_points": 1
	},
	"W07-5": {
		"games": ["m1",
				  "m2"],
		"enemy": "goblin",
		"background": "green_field",
		"skill_points": 1
	},
	"W07-X": {
		"games": ["m1", "a1", "f1", "c1", "r1",
				  "m2", "a2", "f2", "c2", "r2"],
		"enemy": "goblin",
		"background": "green_field",
		"skill_points": 3
	},
	"W08-1": {
		"games": ["m1", "r1",
				  "m2", "r2"],
		"enemy": "slime",
		"background": "autumn_forest",
		"skill_points": 1
	},
	"W08-2": {
		"games": ["a1", "r1",
				  "a2", "r2"],
		"enemy": "slime",
		"background": "autumn_forest",
		"skill_points": 1
	},
	"W08-3": {
		"games": ["m1", "f1",
				  "m2", "f2"],
		"enemy": "zombie",
		"background": "autumn_forest",
		"skill_points": 1
	},
	"W08-4": {
		"games": ["a1", "f1",
				  "a2", "f2"],
		"enemy": "zombie",
		"background": "autumn_forest",
		"skill_points": 1
	},
	"W08-5": {
		"games": ["f1", "r1",
				  "f2", "r2"],
		"enemy": "goblin",
		"background": "autumn_forest",
		"skill_points": 1
	},
	"W08-I": {
		"games": ["f2"],
		"enemy": "goblin",
		"background": "autumn_forest",
		"skill_points": 0
	},
	"W08-X": {
		"games": ["m1", "a1", "f1", "c1", "r1",
				  "m2", "a2", "f2", "c2", "r2"],
		"enemy": "goblin",
		"background": "autumn_forest",
		"skill_points": 3
	},
	"W09-1": {
		"games": ["m1", "a1",
				  "m2", "a2"],
		"enemy": "slime",
		"background": "desert",
		"skill_points": 1
	},
	"W09-2": {
		"games": ["m1", "c1",
				  "m2", "c2"],
		"enemy": "slime",
		"background": "desert",
		"skill_points": 1
	},
	"W09-3": {
		"games": ["a1", "c1",
				  "a2", "c2"],
		"enemy": "zombie",
		"background": "desert",
		"skill_points": 1
	},
	"W09-4": {
		"games": ["f1", "c1",
				  "f2", "c2"],
		"enemy": "zombie",
		"background": "desert",
		"skill_points": 1
	},
	"W09-5": {
		"games": ["c1", "r1",
				  "c2", "r2"],
		"enemy": "goblin",
		"background": "desert",
		"skill_points": 1
	},
	"W09-I": {
		"games": ["c2"],
		"enemy": "goblin",
		"background": "desert",
		"skill_points": 0
	},
	"W09-X": {
		"games": ["m1", "a1", "f1", "c1", "r1",
				  "m2", "a2", "f2", "c2", "r2"],
		"enemy": "goblin",
		"background": "desert",
		"skill_points": 3
	},
	"W10-1": {
		"games": ["m1", "c1", "r1",
				  "m2", "c2", "r2"],
		"enemy": "slime",
		"background": "forest",
		"skill_points": 1
	},
	"W10-2": {
		"games": ["m1", "a1", "f1",
				  "m2", "a2", "f2"],
		"enemy": "slime",
		"background": "forest",
		"skill_points": 1
	},
	"W10-3": {
		"games": ["m1", "a1", "r1",
				  "m2", "a2", "r2"],
		"enemy": "zombie",
		"background": "forest",
		"skill_points": 1
	},
	"W10-4": {
		"games": ["m1", "f1", "c1",
				  "m2", "f2", "c2"],
		"enemy": "zombie",
		"background": "forest",
		"skill_points": 1
	},
	"W10-5": {
		"games": ["m1", "f1", "r1",
				  "m2", "f2", "r2"],
		"enemy": "goblin",
		"background": "forest",
		"skill_points": 1
	},
	"W10-I": {
		"games": ["m2"],
		"enemy": "goblin",
		"background": "forest",
		"skill_points": 0
	},
	"W10-X": {
		"games": ["m1", "a1", "f1", "c1", "r1",
				  "m2", "a2", "f2", "c2", "r2"],
		"enemy": "goblin",
		"background": "forest",
		"skill_points": 3
	},
	"W11-1": {
		"games": ["f1", "c1", "r1",
				  "f2", "c2", "r2"],
		"enemy": "slime",
		"background": "winter",
		"skill_points": 1
	},
	"W11-2": {
		"games": ["a1", "f1", "c1",
				  "a2", "f2", "c2"],
		"enemy": "slime",
		"background": "winter",
		"skill_points": 1
	},
	"W11-3": {
		"games": ["a1", "f1", "r1",
				  "a2", "f2", "r2"],
		"enemy": "zombie",
		"background": "winter",
		"skill_points": 1
	},
	"W11-4": {
		"games": ["a1", "c1", "r1",
				  "a2", "c2", "r2"],
		"enemy": "zombie",
		"background": "winter",
		"skill_points": 1
	},
	"W11-5": {
		"games": ["m1", "a1", "c1",
				  "m2", "a2", "c2"],
		"enemy": "goblin",
		"background": "winter",
		"skill_points": 1
	},
	"W11-I": {
		"games": ["a2"],
		"enemy": "goblin",
		"background": "winter",
		"skill_points": 0
	},
	"W11-X": {
		"games": ["m1", "a1", "f1", "c1", "r1",
				  "m2", "a2", "f2", "c2", "r2"],
		"enemy": "goblin",
		"background": "winter",
		"skill_points": 3
	},
	"W12-1": {
		"games": ["a1", "f1", "c1", "r1",
				  "a2", "f2", "c2", "r2"],
		"enemy": "slime",
		"background": "green_field",
		"skill_points": 1
	},
	"W12-2": {
		"games": ["m1", "f1", "c1", "r1",
				  "m2", "f2", "c2", "r2"],
		"enemy": "slime",
		"background": "green_field",
		"skill_points": 1
	},
	"W12-3": {
		"games": ["m1", "a1", "c1", "r1",
				  "m2", "a2", "c2", "r2"],
		"enemy": "zombie",
		"background": "green_field",
		"skill_points": 1
	},
	"W12-4": {
		"games": ["m1", "a1", "f1", "r1",
				  "m2", "a2", "f2", "r2"],
		"enemy": "zombie",
		"background": "green_field",
		"skill_points": 1
	},
	"W12-5": {
		"games": ["m1", "a1", "f1", "c1",
				  "m2", "a2", "f2", "c2"],
		"enemy": "goblin",
		"background": "green_field",
		"skill_points": 1
	},
	"W12-I": {
		"games": ["m1", "a1", "f1", "c1", "r1",
				  "m2", "a2", "f2", "c2", "r2"],
		"enemy": "goblin",
		"background": "green_field",
		"skill_points": 0
	},
	"W12-X": {
		"games": ["m1", "a1", "f1", "c1", "r1",
				  "m2", "a2", "f2", "c2", "r2"],
		"enemy": "goblin",
		"background": "green_field",
		"skill_points": 5
	},
}

var stage_graph = {
	"Start": ["W01-1"],
	
	"W01-1": ["W01-2"],
	"W01-2": ["W01-3"],
	"W01-3": ["W01-4"],
	"W01-4": ["W01-5"],
	"W01-5": ["W01-B"],
	"W01-B": ["W02-1", "W03-1"],
	
	"W02-1": ["W02-2"],
	"W02-2": ["W02-3"],
	"W02-3": ["W02-4", "W02-5"],
	"W02-4": ["W02-I"],
	"W02-5": ["W02-B"],
	"W02-I": [],
	"W02-B": ["W04-1"],
	
	"W03-1": ["W03-2"],
	"W03-2": ["W03-3"],
	"W03-3": ["W03-4"],
	"W03-4": ["W03-5"],
	"W03-5": ["W03-I", "W03-B"],
	"W03-I": [],
	"W03-B": [],
	
	"W04-1": ["W04-2"],
	"W04-2": ["W04-3"],
	"W04-3": ["W04-4"],
	"W04-4": ["W04-5", "W04-B"],
	"W04-5": ["W04-I", "W06-2"],
	"W04-I": [],
	"W04-B": [],
	
	"W05-1": ["W05-2"],
	"W05-2": ["W05-3"],
	"W05-3": ["W05-4"],
	"W05-4": ["W05-5", "W05-B"],
	"W05-5": ["W05-I"],
	"W05-I": [],
	"W05-B": ["W06-1"],
	
	"W06-1": ["W06-2"],
	"W06-2": ["W06-3"],
	"W06-3": ["W06-4"],
	"W06-4": ["W06-5", "W06-I"],
	"W06-5": ["W06-B"],
	"W06-I": [],
	"W06-B": ["W07-1"],
	
	"W07-1": ["W07-2"],
	"W07-2": ["W07-3"],
	"W07-3": ["W07-4", "W08-1"],
	"W07-4": ["W07-5"],
	"W07-5": ["W07-B"],
	"W07-B": ["W09-1"],
	
	"W08-1": ["W08-2"],
	"W08-2": ["W08-3"],
	"W08-3": ["W08-4"],
	"W08-4": ["W08-5", "W08-B"],
	"W08-5": ["W08-I"],
	"W08-I": [],
	"W08-B": ["W10-1"],
	
	"W09-1": ["W09-2"],
	"W09-2": ["W09-3"],
	"W09-3": ["W09-4", "W09-I"],
	"W09-4": ["W09-5", "W11-1"],
	"W09-5": ["W09-B"],
	"W09-I": [],
	"W09-B": [],
	
	"W10-1": ["W10-2"],
	"W10-2": ["W10-3"],
	"W10-3": ["W10-4", "W10-5"],
	"W10-4": ["W10-I"],
	"W10-5": ["W10-B"],
	"W10-I": [],
	"W10-B": ["W12-1"],
	
	"W11-1": ["W11-2"],
	"W11-2": ["W11-3"],
	"W11-3": ["W11-4"],
	"W11-4": ["W11-5", "W11-B"],
	"W11-5": ["W11-I"],
	"W11-I": [],
	"W11-B": ["W12-1"],
	
	"W12-1": ["W12-2"],
	"W12-2": ["W12-3"],
	"W12-3": ["W12-4", "W12-I"],
	"W12-4": ["W12-5"],
	"W12-5": ["W12-B"],
	"W12-I": [],
	"W12-B": []
}

func is_stage_unlocked(id):
	if id == "W01-1":
		return true
	
	for stage_id in stage_graph.keys():
		var completed = State.save_data.get(stage_id, false)
		
		if completed:
			if id in stage_graph[stage_id]:
				return true
	
	return false

func is_stage_completed(id):
	return State.save_data.get(id, false)

# Testar grafo, apagar depois
func validate_graph():
	print("Oi")
	for from in stage_graph:
		for to in stage_graph[from]:
			if not stage_graph.has(to):
				print("ERRO: fase não existe:", to)
