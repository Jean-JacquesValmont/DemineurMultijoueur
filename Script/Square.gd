extends Sprite2D

var i = null
var j = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if GlobalVariable.firstSquareClicked == false:
			get_node("SquareEmpty").visible = true
			placeBombs(GlobalVariable.bomb)
			GlobalVariable.firstSquareClicked = true
			print("i: ", i)
			print("j: ", j)
		else:
			if GlobalVariable.boardGame[i][j] == null:
				get_node("SquareEmpty").visible = true
			else:
				get_node("SquareWithBomb").visible = true
			print("i: ", i)
			print("j: ", j)
	

# Placer aléatoirement les bombes dans le tableau
func placeBombs(numberOfBomb):
	var placedBombs = 0
	while placedBombs < numberOfBomb:
		var random_row = randi() % int(GlobalVariable.line)
		var random_col = randi() % int(GlobalVariable.column)

		# Vérifie s'il n'y a pas déjà une bombe à cette position
		if GlobalVariable.boardGame[random_row][random_col] != "bomb" and random_row != i and random_col != j:
			GlobalVariable.boardGame[random_row][random_col] = "bomb"
			placedBombs += 1
	print("Bombs placed:", GlobalVariable.boardGame)
