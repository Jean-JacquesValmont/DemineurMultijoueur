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
		BoardCreated = true

func createGameBoard():
	for i in range(0,GlobalVariable.column):
		for j in range(0,GlobalVariable.line):
			# Créer une instance de la scène Square
			var square_instance = NewSquare.instantiate()
			
			# Définir la position de l'instance
			square_instance.position = Vector2(100 + i*50, 100 + j*50)
			
			# Ajouter l'instance comme enfant de ce nœud
			add_child(square_instance)

func createBoardArray(rowSize,columnSize):
	for i in range(rowSize):
		var row = []
		for j in range(columnSize):
			row.append(null)
		GlobalVariable.boardGame.append(row)
	#print(GlobalVariable.boardGame)

func _on_button_pressed():
	GlobalVariable.boardGame = []
	GlobalVariable.line = 5
	GlobalVariable.column = 5
	GlobalVariable.bomb = 1
	GlobalVariable.firstSquareClicked = false
	get_tree().change_scene_to_file("res://Scene/Menu.tscn")
