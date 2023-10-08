extends Node2D

#Types
const Character = preload("res://player_character/player_character.gd");
const Zombie = preload("res://enemies/zombie/zombie.gd");
const CharacterSpawner = preload("res://character_controller/character_controller.gd");

#Scenes
var _zombie_scene = preload("res://enemies/zombie/zombie.tscn");

#onready
@onready var _characterSpawner:CharacterSpawner = get_parent().get_node("character_controller");

var _timer: float;
var _spawnTime: float = 2;
var _counter: int = 0;
var _max_count: int = 50;
var _zombies: Array[Zombie] = [];

var _increaseSpawnRateTime: float = 5;
var _increaseSpawnRateTimer: float = _increaseSpawnRateTime;
var _increaseSpawnRateInterval: float = 0.2;
var _minSpawnRateTime: float = 0.3;


signal zombie_died;


func _ready():
	_timer = _spawnTime;
	_characterSpawner.character_died.connect(_characterDied);


func _process(delta):
	_timer -= delta;
	
	if(_counter < _max_count && _timer <= 0):
		_timer = _spawnTime;
		var zombie: Zombie = _zombie_scene.instantiate();
		zombie.global_position = self.global_position;
		zombie.on_death.connect(_zombieDied); 
		zombie.needs_new_target.connect(_getNewTarget);
		_zombies.append(zombie);
		
		add_child(zombie);
		_counter+= 1;
	
	_spawnRateIncreaseTimer(delta);


func _spawnRateIncreaseTimer(delta: float):
	if(_spawnTime > _minSpawnRateTime):
		if(_increaseSpawnRateTimer > 0):
			_increaseSpawnRateTimer -= delta;
		else:
			_spawnTime -= _increaseSpawnRateInterval;
			_increaseSpawnRateTimer = _increaseSpawnRateTime;
	elif(_spawnTime < _minSpawnRateTime):
		_spawnTime = _minSpawnRateTime;


func _zombieDied(zombie: Zombie):
	zombie_died.emit(zombie);
	var index = _zombies.find(zombie);
	
	if(index != -1):
		_zombies.remove_at(index);

func _characterDied(character: Character):
	for zombie in _zombies:
		zombie._remove_character(character);

func _getNewTarget(zombie: Zombie):
	var character = _characterSpawner._get_closest_character(zombie.global_position);
	zombie._setTarget(character);
