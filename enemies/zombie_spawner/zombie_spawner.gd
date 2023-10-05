extends Node2D

var _zombie_scene = preload("res://enemies/zombie/zombie.tscn");
var _timer: float;
var _spawnTime: float = 2;
var _counter: int = 0;
var _max_count: int = 50;
var _zombies: Array = [];

var _increaseSpawnRateTime: float = 5;
var _increaseSpawnRateTimer: float = _increaseSpawnRateTime;
var _increaseSpawnRateInterval: float = 0.2;
var _minSpawnRateTime: float = 0.3;

func _ready():
	_timer = _spawnTime;

	
func _process(delta):
	_timer -= delta;
	
	if(_counter < _max_count && _timer <= 0):
		_timer = _spawnTime;
		var zombie = _zombie_scene.instantiate();
		zombie.global_position = self.global_position;
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
	





