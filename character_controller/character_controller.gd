extends Node2D

# Types
const char_scene = preload("res://player_character/player_character.tscn");
const Character = preload("res://player_character/player_character.gd");
const Zombie = preload("res://enemies/zombie/zombie.gd");
const ZombieSpawner = preload("res://enemies/zombie_spawner/zombie_spawner.gd");
@onready var _zombieSpawner: ZombieSpawner = get_parent().get_node("ZombieSpawner");

var characters: Array[Character];
var index = 0;
var selected_character: int;
var just_selected_character: bool = false;

signal character_died;

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 1:
		var character: Character = char_scene.instantiate();
		character.position = Vector2(i * 100, 200);
		character._index = i;
		character.on_death.connect(_characterDeath);
		add_child(character);
		characters.push_back(character);
	
	_zombieSpawner.zombie_died.connect(_zombieDied);


func _characterDeath(character: Character):
	character_died.emit(character);
	var index = characters.find(character);
	if(index != -1):
		characters.remove_at(index);
	
	if(characters.size() == 0):
		print('Game Over!');
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed('select')):
		_on_select();
	


func _try_select_character() -> bool:
	var clickLocation = get_global_mouse_position();
	
	for character in characters:
		if(clickLocation.distance_to(character.position) <= 50):
			selected_character = character._index;
			just_selected_character = true;
			return true;
		
	just_selected_character = false;
	return false;


func _on_select():
	_try_select_character();
	
	if(!just_selected_character):
		characters[selected_character]._set_destination(get_global_mouse_position());
		index+=1;


func _get_closest_character(origin: Vector2):
	var closest;
	var closestDistance = -1;
	
	for	character in characters:
		var currentDistance = origin.distance_to(character.position);
		
		if(closestDistance == -1 || currentDistance < closestDistance):
			closestDistance = currentDistance;
			closest = character;
		
	return closest;


func _zombieDied(zombie: Zombie):
	for character in characters:
		character._remove_zombie(zombie);

