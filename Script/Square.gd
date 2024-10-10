extends Sprite2D


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
		else:
			get_node("SquareEmpty").visible = true

# Placer aléatoirement les bombes dans le tableau
func placeBombs(numberOfBomb):
	var placed_bombs = 0
	while placed_bombs < numberOfBomb:
		var random_row = randi() % int(GlobalVariable.line)
		var random_col = randi() % int(GlobalVariable.column)

		# Vérifie s'il n'y a pas déjà une bombe à cette position
		if GlobalVariable.boardGame[random_row][random_col] != "bomb":
			GlobalVariable.boardGame[random_row][random_col] = "bomb"
			placed_bombs += 1
	print("Bombs placed:", GlobalVariable.boardGame)
