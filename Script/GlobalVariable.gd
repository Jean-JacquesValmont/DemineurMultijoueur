extends Node

var peer = ENetMultiplayerPeer.new()
var rng = RandomNumberGenerator.new()
var boardGame = []
var line = 9
var column = 9
var bomb = 10
var timer = 10
var turnPlayer1 = true
var firstSquareClicked = false
var bombExplosed = false
var winGame = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
