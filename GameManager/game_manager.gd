extends Node2D

enum GameState{ MainMenu, InGame, GameOver};

#signals
signal toggle_pause; #emit with isPaused;
signal start_game;
signal game_over;

var isPaused = false;
var currentGameState = GameState.MainMenu;




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed('Action')):
		_loadLevel();


func _togglePause():
	isPaused = !isPaused;
	toggle_pause.emit(isPaused);


func _loadLevel():
	start_game.emit();


func _gameOver():
	game_over.emit();
	print('Game Over!');
	currentGameState = GameState.GameOver;

# TODO: Luke this needs to actually load the level. Then, when loaded, emit start game.
func _restart():
	_loadLevel();
	currentGameState = GameState.InGame;
