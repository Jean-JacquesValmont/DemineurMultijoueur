extends Node2D

var NewSquare = preload("res://Scene/Square.tscn")
var BoardCreated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if BoardCreated == false:
		createGameBoard()

func createGameBoard():
	for i in range(0,5):
		for j in range(0,5):
			# Créer une instance de la scène Square
			var square_instance = NewSquare.instantiate()
			
			# Définir la position de l'instance
			square_instance.position = Vector2(i*50, j*50)
			
			# Ajouter l'instance comme enfant de ce nœud
			get_parent().add_child(square_instance)
	BoardCreated = true
