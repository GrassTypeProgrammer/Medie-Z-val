extends Control

@onready var startButton:Button = $VBoxContainer/StartButton;
# Called when the node enters the scene tree for the first time.
func _ready():
	startButton.pressed.connect(_start_game);
	

func _start_game():
	SceneManager._loadLevel(SceneManager.Levels.Level1);


