extends CanvasLayer

@onready var gameOverUI: Node = $Control;
var enabled: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	_disableGameOverUI();
	GameManager.game_over.connect(_enableGameOverUI);
	GameManager.start_game.connect(_disableGameOverUI);


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
	
