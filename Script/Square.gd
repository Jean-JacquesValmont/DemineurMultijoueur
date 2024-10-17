extends Sprite2D

var i = null
var j = null
var hasClicked = false
var numberOfBombAround = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hasClicked == true:
		searchSquareEmpty()
		checkWinGame()
		hasClicked = false
	get_parent().get_parent().get_node("TimerTextPlayer1").text = "Temps restant: %.2f" % get_parent().get_parent().get_node("TimerPlayer1").time_left
	get_parent().get_parent().get_node("TimerTextPlayer2").text = "Temps restant: %.2f" % get_parent().get_parent().get_node("TimerPlayer2").time_left

func _on_area_2d_input_event(viewport, event, shape_idx):
	if GlobalVariable.bombExplosed == false and GlobalVariable.winGame == false:
		if event is InputEventMouseButton:
			if multiplayer.get_unique_id() == 1 and GlobalVariable.turnPlayer1 == true:
				if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
					rpc("firstClickSeed")
					rpc("clickSquare")
					rpc("startTimerPlayer2")
			if multiplayer.get_unique_id() != 1 and GlobalVariable.turnPlayer1 == false:
				if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
					rpc("firstClickSeed")
					rpc("clickSquare")
					rpc("startTimerPlayer1")
			if event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
				displayFlag()

@rpc("any_peer", "call_local") func clickSquare():
	if GlobalVariable.firstSquareClicked == false:
		firstClickSquare()
	elif GlobalVariable.firstSquareClicked == true:
		noFirstClickSquare()
	GlobalVariable.turnPlayer1 = !GlobalVariable.turnPlayer1

func firstClickSquare():
	get_node("SquareEmpty").visible = true
	placeBombs(GlobalVariable.bomb)
	hasClicked = true
	GlobalVariable.boardGame[i][j] = "reveal"
	GlobalVariable.firstSquareClicked = true

func noFirstClickSquare():
	if GlobalVariable.boardGame[i][j] == "reveal":
		return
	elif GlobalVariable.boardGame[i][j] == "hidden":
		get_node("SquareEmpty").visible = true
		GlobalVariable.boardGame[i][j] = "reveal"
		hasClicked = true
	elif GlobalVariable.boardGame[i][j] == "bomb":
		get_node("SquareWithBomb").visible = true
		if multiplayer.get_unique_id() == 1 and GlobalVariable.turnPlayer1 == true:
			GlobalVariable.bombExplosed = true
		if multiplayer.get_unique_id() != 1 and GlobalVariable.turnPlayer1 == true:
			GlobalVariable.winGame = true
		if multiplayer.get_unique_id() == 1 and GlobalVariable.turnPlayer1 == false:
			GlobalVariable.winGame = true
		if multiplayer.get_unique_id() != 1 and GlobalVariable.turnPlayer1 == false:
			GlobalVariable.bombExplosed = true

func displayFlag():
	if get_node("SquareWithFlag").visible == false and get_node("SquareEmpty").visible == false:
		get_node("SquareWithFlag").visible = true
	elif get_node("SquareWithFlag").visible == true:
		get_node("SquareWithFlag").visible = false

@rpc("any_peer", "call_local") func setRandomSeed(seed_value: int):
	GlobalVariable.rng.seed = seed_value # Fixe la graine pour avoir la même séquence sur tous les joueurs

@rpc("any_peer", "call_local") func firstClickSeed():
	var seed_value = RandomNumberGenerator.new().randi()
	# Envoie la graine à tous les joueurs pour la synchronisation
	rpc("setRandomSeed", seed_value)

# Place les bombes avec un générateur de nombres aléatoires synchronisé
func placeBombs(numberOfBomb):
	var placedBombs = 0
	while placedBombs < numberOfBomb:
		var random_row = GlobalVariable.rng.randi_range(0, int(GlobalVariable.line) - 1)
		var random_col = GlobalVariable.rng.randi_range(0, int(GlobalVariable.column) - 1)

		# Vérifie s'il n'y a pas déjà une bombe à cette position
		if GlobalVariable.boardGame[random_row][random_col] != "bomb" and random_row != i and random_col != j:
			GlobalVariable.boardGame[random_row][random_col] = "bomb"
			placedBombs += 1
	print("Bombs placed:", GlobalVariable.boardGame)

func checkSquare(iParam, jParam, offset_I, offset_J):
	# Vérifie que les indices sont dans les limites du tableau
	if (iParam + offset_I >= 0 and iParam + offset_I < GlobalVariable.line) and (jParam + offset_J >= 0 and jParam + offset_J < GlobalVariable.column):
		# Si la case contient une bombe
		if GlobalVariable.boardGame[iParam + offset_I][jParam + offset_J] == "bomb":
			numberOfBombAround += 1

func revealSquare(iParam, jParam, offset_I, offset_J):
	# Vérifie que les indices sont dans les limites du tableau
	if (iParam + offset_I >= 0 and iParam + offset_I < GlobalVariable.line) and (jParam + offset_J >= 0 and jParam + offset_J < GlobalVariable.column):
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
	for f in range(0, GlobalVariable.line):
		print("Line ", f ,  " : " , GlobalVariable.boardGame[f])

@rpc("any_peer", "call_local") func startTimerPlayer1():
	get_parent().get_parent().get_node("TimerPlayer1").start()
	get_parent().get_parent().get_node("TimerPlayer2").stop()

@rpc("any_peer", "call_local") func startTimerPlayer2():
	get_parent().get_parent().get_node("TimerPlayer2").start()
	get_parent().get_parent().get_node("TimerPlayer1").stop()
	
func checkWinGame():
	for f in range(0,GlobalVariable.line):
			for ff in range(0,GlobalVariable.column):
				if GlobalVariable.boardGame[f][ff] == "hidden":
					return
	GlobalVariable.winGame = true
