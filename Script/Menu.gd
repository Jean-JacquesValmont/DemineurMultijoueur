extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_spin_box_line_value_changed(value):
	GlobalVariable.line = get_node("Settings/SpinBoxLine").value

func _on_spin_box_column_value_changed(value):
	GlobalVariable.column = get_node("Settings/SpinBoxColumn").value

func _on_spin_box_bomb_value_changed(value):
	GlobalVariable.bomb = get_node("Settings/SpinBoxBomb").value
	
func _on_button_play_button_down():
	var sizeBoard = GlobalVariable.line * GlobalVariable.column
	
	if GlobalVariable.bomb >= sizeBoard:
		pass
	else:
		get_tree().change_scene_to_file("res://Scene/Game.tscn")
