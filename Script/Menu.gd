extends Control

@export var player_scene: PackedScene = preload("res://Scene/Square.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_host_pressed():
	GlobalVariable.peer.create_server(135)
	multiplayer.multiplayer_peer = GlobalVariable.peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)

func _on_button_join_pressed():
	GlobalVariable.peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = GlobalVariable.peer

func _on_spin_box_line_value_changed(value):
	GlobalVariable.line = get_node("Settings/SpinBoxLine").value

func _on_spin_box_column_value_changed(value):
	GlobalVariable.column = get_node("Settings/SpinBoxColumn").value

func _on_spin_box_bomb_value_changed(value):
	GlobalVariable.bomb = get_node("Settings/SpinBoxBomb").value

@rpc("any_peer", "call_local") func changeScene():
	get_tree().change_scene_to_file("res://Scene/Game.tscn")

func _on_button_play_button_down():
	var sizeBoard = GlobalVariable.line * GlobalVariable.column
	
	if GlobalVariable.bomb*2 >= sizeBoard:
		get_node("Settings/ErrorText").text = "Le nombre de bombes est trop important pour la taille du tableau."
	else:
		rpc("changeScene")


