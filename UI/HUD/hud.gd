extends Control

@onready var _zombieSpawner: Constants.ZombieSpawner = get_parent().get_node("ZombieSpawner");
@onready var killCountText: RichTextLabel = $HBoxContainer/VBoxContainer/KillCountText;

# Called when the node enters the scene tree for the first time.
func _ready():
	_zombieSpawner.kill_count_changed.connect(_updateKillCount);


func _updateKillCount(count: int):
	killCountText.clear();
	killCountText.add_text('Kill Count: ' + str(count));
