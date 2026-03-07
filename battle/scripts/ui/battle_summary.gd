extends Control

@onready var title_label = $Overlay/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var hits_value = $Overlay/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/StatsContainer/HitsPanel/MarginContainer/HBoxContainer/Value
@onready var misses_value = $Overlay/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/StatsContainer/MissesPanel/MarginContainer/HBoxContainer/Value
@onready var damage_value = $Overlay/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/StatsContainer/DamagePanel/MarginContainer/HBoxContainer/Value
@onready var time_value = $Overlay/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/StatsContainer/TimePanel/MarginContainer/HBoxContainer/Value
@onready var accuracy_value = $Overlay/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/StatsContainer/AccuracyPanel/MarginContainer/HBoxContainer/Value
@onready var xp_label = $Overlay/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/XPLabel
@onready var rewards_label = $Overlay/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/RewardsLabel

var summary_data: Dictionary = {}

func _ready():
	for b in get_tree().get_nodes_in_group("se_buttons"):
		b.connect("pressed", Callable(self, "_on_any_button_pressed"))
		b.connect("mouse_entered", Callable(self, "_on_any_button_entered"))

func show_summary(stats: Dictionary, victory: bool, xp_gained: int = 0):
	summary_data = stats
	
	if victory:
		title_label.text = "VITÓRIA!"
		title_label.add_theme_color_override("font_color", Color(1, 0.84, 0))
	else:
		title_label.text = "DERROTA..."
		title_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3)) 
	
	hits_value.text = str(stats.get("hits", 0))
	misses_value.text = str(stats.get("misses", 0))
	damage_value.text = str(stats.get("total_damage", 0))
	time_value.text = "%.1fs" % stats.get("time_taken", 0.0)
	accuracy_value.text = "%.1f%%" % stats.get("accuracy", 0.0)
	
	if victory and xp_gained > 0:
		xp_label.text = "+%d XP" % xp_gained
		xp_label.visible = true
		rewards_label.visible = true
	else:
		xp_label.visible = false
		rewards_label.visible = false
	
	visible = true

func _on_continue_pressed():
	queue_free()

func _on_any_button_pressed():
	print("Botão continuar pressionado!")
	SESelect.play()

func _on_any_button_entered():
	SEMouseEntered.play()
