extends Node2D

enum Levels { MainMenu, Level1}

@onready var Level1 = Constants.Level1;
@onready var MainMenu = Constants.MainMenu;
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
			currentLevel = MainMenu.instantiate();
			currentLevel.size = Vector2(1920, 1080);
			gameRoot.add_child(currentLevel);
		Levels.Level1:
			currentLevel = Level1.instantiate();
			gameRoot.add_child(currentLevel);
			GameManager._loadLevel();
	


