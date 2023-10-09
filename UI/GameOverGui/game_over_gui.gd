extends CanvasLayer

@onready var gameOverUI: Node = $Control;
@onready var restartButton: Button = $Control/VBoxContainer/MarginContainer/RestartButton;
var enabled: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	_disableGameOverUI();
	GameManager.game_over.connect(_enableGameOverUI);
	GameManager.start_game.connect(_disableGameOverUI);
	restartButton.button_up.connect(_restartPressed);


func _enableGameOverUI():
	self.add_child(gameOverUI);
	enabled = true;
	gameOverUI.set_process(enabled);
	gameOverUI.show();

func _disableGameOverUI():
	self.remove_child(gameOverUI);
	enabled = false;
	gameOverUI.set_process(enabled);
	gameOverUI.hide();

func _restartPressed():
	GameManager._restart();