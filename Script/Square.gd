extends Sprite2D

var i = null
var j = null
var hasClicked = false
var numberOfBombAround = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hasClicked == true:
		searchSquareEmpty()
		checkWinGame()
		hasClicked = false

func _on_area_2d_input_event(viewport, event, shape_idx):
	if GlobalVariable.bombExplosed == false and GlobalVariable.winGame == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
				if GlobalVariable.firstSquareClicked == false:
					get_node("SquareEmpty").visible = true
					placeBombs(GlobalVariable.bomb)
					hasClicked = true
					GlobalVariable.firstSquareClicked = true
				elif GlobalVariable.firstSquareClicked == true:
					if GlobalVariable.boardGame[i][j] == "reveal":
						return
					elif GlobalVariable.boardGame[i][j] == "hidden":
						get_node("SquareEmpty").visible = true
						GlobalVariable.boardGame[i][j] = "reveal"
						hasClicked = true
					elif GlobalVariable.boardGame[i][j] == "bomb":
						get_node("SquareWithBomb").visible = true
						GlobalVariable.bombExplosed = true

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

func checkSquare(iParam, jParam, offset_I, offset_J):
	# Vérifie que les indices sont dans les limites du tableau
	if (iParam + offset_I >= 0 and iParam + offset_I < GlobalVariable.column) and (jParam + offset_J >= 0 and jParam + offset_J < GlobalVariable.line):
		# Si la case contient une bombe
		if GlobalVariable.boardGame[iParam + offset_I][jParam + offset_J] == "bomb":
			numberOfBombAround += 1

func revealSquare(iParam, jParam, offset_I, offset_J):
	# Vérifie que les indices sont dans les limites du tableau
	if (iParam + offset_I >= 0 and iParam + offset_I < GlobalVariable.column) and (jParam + offset_J >= 0 and jParam + offset_J < GlobalVariable.line):
		# Si la case est vide
		if GlobalVariable.boardGame[iParam + offset_I][jParam + offset_J] == "hidden":
			var numberOfChildren = get_parent().get_child_count()
			for f in range(numberOfChildren):
				# Vérifie si le carré correspondant est trouvé
				if get_parent().get_child(f).i == iParam + offset_I and get_parent().get_child(f).j == jParam + offset_J:
					get_parent().get_child(f).get_node("SquareEmpty").visible = true
					GlobalVariable.boardGame[iParam + offset_I][jParam + offset_J] = "reveal"

func checkAroundSquare(iParam,jParam):
	numberOfBombAround = 0
	checkSquare(iParam,jParam,-1,0)
	checkSquare(iParam,jParam,-1,1)
	checkSquare(iParam,jParam,0,1)
	checkSquare(iParam,jParam,1,1)
	checkSquare(iParam,jParam,1,0)
	checkSquare(iParam,jParam,1,-1)
	checkSquare(iParam,jParam,0,-1)
	checkSquare(iParam,jParam,-1,-1)
	
	if numberOfBombAround == 0:
		revealSquare(iParam,jParam,-1,0)
		revealSquare(iParam,jParam,-1,1)
		revealSquare(iParam,jParam,0,1)
		revealSquare(iParam,jParam,1,1)
		revealSquare(iParam,jParam,1,0)
		revealSquare(iParam,jParam,1,-1)
		revealSquare(iParam,jParam,0,-1)
		revealSquare(iParam,jParam,-1,-1)

func searchSquareEmpty():
	var numberOfChildren = get_parent().get_child_count()
	var prevVisibleCount = -1
	var currentVisibleCount = 0
	
	# Répète jusqu'à ce que le nombre de carrés visibles ne change plus
	while currentVisibleCount != prevVisibleCount:
		prevVisibleCount = currentVisibleCount
		currentVisibleCount = 0
		
		for f in range(numberOfChildren):
			var child = get_parent().get_child(f)
			var squareEmptyNode = child.get_node("SquareEmpty")
			
			# Si le carré est déjà visible, on le traite
			if squareEmptyNode.visible:
				currentVisibleCount += 1
				# Vérifie les cases autour de ce carré
				checkAroundSquare(child.i, child.j)
				
				if numberOfBombAround > 0:
					child.get_node("NumberOfBombAround").visible = true
					child.get_node("NumberOfBombAround").text = str(numberOfBombAround)
		
	print("Board updated: ")
	for f in range(0, GlobalVariable.column):
		print("Line ", f ,  " : " , GlobalVariable.boardGame[f])

func checkWinGame():
	for f in range(0,GlobalVariable.line):
			for ff in range(0,GlobalVariable.column):
				if GlobalVariable.boardGame[f][ff] == "hidden":
					return
	GlobalVariable.winGame = true
