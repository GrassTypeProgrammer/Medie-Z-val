extends Node2D

enum GameState{ MainMenu, InGame, GameOver};

#signals
signal toggle_pause; #emit with isPaused;
signal start_game;
signal game_over;

var isPaused = false;
var currentGameState = GameState.MainMenu;



# Called when the node enters the scene tree for the first time.
func _ready():
	print('here');

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed('Action')):
		_loadLevel();


func _togglePause():
	isPaused = !isPaused;
	toggle_pause.emit(isPaused);


# TODO: Luke this needs to actually load the level. Then, when loaded, emit start game.
func _loadLevel():
	start_game.emit();
	currentGameState = GameState.InGame;


func _gameOver():
	game_over.emit();
	print('Game Over!');
	currentGameState = GameState.GameOver;
