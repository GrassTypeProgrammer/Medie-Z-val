extends Node2D

enum Levels { MainMenu, Level1}

@onready var level1 = preload("res://levels/zombie_test_level/zombie_test_scene.tscn");
@onready var mainMenu = preload("res://levels/main_menu/main_menu.tscn");
var gameRoot:Node2D;
var currentLevel;

# Called when the node enters the scene tree for the first time.
func _ready():
	var childCount = get_parent().get_child_count();
	gameRoot =  get_parent().get_child(childCount-1);
	_loadLevel(Levels.MainMenu);


func _loadLevel(level:Levels):
	if(currentLevel):
		currentLevel.queue_free();
	
	match level:
		Levels.MainMenu:
			currentLevel = mainMenu.instantiate();
			currentLevel.size = Vector2(1920, 1080);
			gameRoot.add_child(currentLevel);
		Levels.Level1:
			currentLevel = level1.instantiate();
			gameRoot.add_child(currentLevel);
			GameManager._loadLevel();
	


