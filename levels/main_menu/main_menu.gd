extends Control

@onready var scene = preload("res://levels/zombie_test_level/zombie_test_scene.tscn");
# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.pressed.connect(_start_game);
	

func _start_game():
	
	get_tree().change_scene_to_packed(scene);


