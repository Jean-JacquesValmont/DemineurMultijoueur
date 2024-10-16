extends Node2D

var NewSquare = preload("res://Scene/Square.tscn")
var BoardCreated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if BoardCreated == false:
		createBoardArray(GlobalVariable.line,GlobalVariable.column)
		createGameBoard()
		initTimer()
		BoardCreated = true
	
	if GlobalVariable.winGame == true:
		get_node("WinText").text = "Game win!"
		get_node("TimerPlayer1").stop()
		get_node("TimerPlayer2").stop()
	elif GlobalVariable.bombExplosed == true:
		get_node("WinText").text = "Game over!"
		get_node("TimerPlayer1").stop()
		get_node("TimerPlayer2").stop()

func createGameBoard():
	for i in range(0,GlobalVariable.line):
		for j in range(0,GlobalVariable.column):
			# Créer une instance de la scène Square
			var square_instance = NewSquare.instantiate()
			
			# Définir les paramètres de l'instance
			square_instance.position = Vector2(100 + j*50, 100 + i*50)
			square_instance.i = i
			square_instance.j = j
			
			# Ajouter l'instance comme enfant de ce nœud
			get_node("BoardGame").add_child(square_instance)

func createBoardArray(rowSize,columnSize):
	for i in range(rowSize):
		var row = []
		for j in range(columnSize):
			row.append("hidden")
		GlobalVariable.boardGame.append(row)
	#print(GlobalVariable.boardGame)

func _on_button_pressed():
	GlobalVariable.boardGame = []
	GlobalVariable.line = 9
	GlobalVariable.column = 9
	GlobalVariable.bomb = 10
	GlobalVariable.timer = 10
	GlobalVariable.firstSquareClicked = false
	GlobalVariable.turnPlayer1 = true
	GlobalVariable.bombExplosed = false
	GlobalVariable.winGame = false
	get_tree().change_scene_to_file("res://Scene/Menu.tscn")

func initTimer():
	get_node("TimerPlayer1").wait_time = GlobalVariable.timer
	get_node("TimerPlayer2").wait_time = GlobalVariable.timer
	get_node("TimerTextPlayer1").text = "Temps restant: %.2f" % GlobalVariable.timer
	get_node("TimerTextPlayer2").text = "Temps restant: %.2f" % GlobalVariable.timer

func _on_timer_player_1_timeout():
	if multiplayer.get_unique_id() == 1 and GlobalVariable.turnPlayer1 == true:
		GlobalVariable.bombExplosed = true
	if multiplayer.get_unique_id() != 1 and GlobalVariable.turnPlayer1 == true:
		GlobalVariable.winGame = true

func _on_timer_player_2_timeout():
	if multiplayer.get_unique_id() == 1 and GlobalVariable.turnPlayer1 == false:
		GlobalVariable.winGame = true
	if multiplayer.get_unique_id() != 1 and GlobalVariable.turnPlayer1 == false:
		GlobalVariable.bombExplosed = true
