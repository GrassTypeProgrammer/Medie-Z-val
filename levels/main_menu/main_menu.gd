extends Control

@onready var startButton: Button = $VBoxContainer/StartButton;
@onready var quitButton: Button = $VBoxContainer/QuitButton;

# Called when the node enters the scene tree for the first time.
func _ready():
	startButton.pressed.connect(_start_game);
	quitButton.pressed.connect(_exitGame);

func _start_game():
	SceneManager._loadLevel(SceneManager.Levels.Level1);

func _exitGame():
	get_tree().quit();
