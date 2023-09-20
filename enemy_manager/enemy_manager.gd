extends Node2D
class_name enemy_manager;

var zombie_scene = preload("res://enemies/basic_zombie/basic_zombie.tscn");
var target;

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 5:
		var zombie = zombie_scene.instantiate();
		zombie.position = Vector2(i * -100, -100);
		add_child(zombie);
		zombie.connect("needsNewTarget", _get_new_target);
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;


func _get_new_target(zombie):
	var target = $"../character_controller"._get_closest_character(zombie.position)
#	return $"../character_controller"._get_closest_character(position);
	zombie._set_new_target(target);
	
