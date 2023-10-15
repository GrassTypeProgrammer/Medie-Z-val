extends CanvasLayer

@onready var gameOverUI: Node = $Control;
@onready var restartButton: Button =$Control/Background/VBoxContainer/MarginContainer/VBoxContainer/RestartButton
@onready var quitButton: Button = $Control/Background/VBoxContainer/MarginContainer/VBoxContainer/QuitButton

const ZombieSpawner = preload("res://enemies/zombie_spawner/zombie_spawner.gd");
@onready var _zombieSpawner:ZombieSpawner = get_parent().get_node("ZombieSpawner");

@onready var killCountLabel: Label =$Control/Background/VBoxContainer/MarginContainer/VBoxContainer/KillCountLabel

var enabled: bool = false;




# Called when the node enters the scene tree for the first time.
func _ready():
	_disableGameOverUI();
	GameManager.game_over.connect(_enableGameOverUI);
	GameManager.start_game.connect(_disableGameOverUI);
	restartButton.button_up.connect(_restartPressed);
	quitButton.button_up.connect(_quitToMainMenu);
	


func _enableGameOverUI():
	self.add_child(gameOverUI);
	enabled = true;
	gameOverUI.set_process(enabled);
	gameOverUI.show();
	killCountLabel.text = 'Kill Count: ' + str(_zombieSpawner._getKillCount());

func _disableGameOverUI():
	self.remove_child(gameOverUI);
	enabled = false;
	gameOverUI.set_process(enabled);
	gameOverUI.hide();

func _restartPressed():
	GameManager._restart();

func _quitToMainMenu():
	SceneManager._loadLevel(SceneManager.Levels.MainMenu);
