extends Node2D

#Types
const Character = Constants.Character;
const Zombie = Constants.Zombie;
const CharacterSpawner = Constants.CharacterSpawner;
const SpawnPoint = Constants.SpawnPoint;

#Scenes
var ZombieScene = Constants.ZombieScene;

#onready
@onready var _characterSpawner:CharacterSpawner = get_parent().get_node("character_controller");
@onready var spawnPoints: Array[SpawnPoint] = [$SpawnPoint1, $SpawnPoint2, $SpawnPoint3, ];

var spawnPointIndex: int = 0;

var _timer: float;
var _spawnTime: float = 2;
var _counter: int = 0;
var _max_count: int = 50;
var _zombies: Array[Zombie] = [];

var _increaseSpawnRateTime: float = 5;
var _increaseSpawnRateTimer: float = _increaseSpawnRateTime;
var _increaseSpawnRateInterval: float = 0.2;
var _minSpawnRateTime: float = 0.3;

var gameStarted: bool = false;

var killCount: int = 0;

signal zombie_died;
signal kill_count_changed;

func _ready():
	_timer = _spawnTime;
	_characterSpawner.character_died.connect(_characterDied);
	GameManager.start_game.connect(_setGameStarted);

func _process(delta):
	_spawnZombies(delta);

func _spawnZombies(delta: float):
	if(gameStarted):
		_timer -= delta;
	
	if(_counter < _max_count && _timer <= 0):
		var spawnLocation = _getSpawnLocation();
		if(spawnLocation != Vector2.ZERO):
			_timer = _spawnTime;
			var zombie: Zombie = ZombieScene.instantiate();
			zombie.global_position = spawnLocation;
			zombie.on_death.connect(_zombieDied); 
			zombie.needs_new_target.connect(_getNewTarget);
			_zombies.append(zombie);
			add_child(zombie);
			_counter+= 1;
		else:
			printerr('Not Enough Spawn Point Capacity!');
		
	_spawnRateIncreaseTimer(delta);

func _setGameStarted():
	gameStarted = true;
	_initialiseVariables();
	_onRestart();

func _initialiseVariables():
	_timer= 0;
	_spawnTime = 2;
	_counter = 0;
	_max_count = 50;
	
	_increaseSpawnRateTime = 5;
	_increaseSpawnRateTimer = _increaseSpawnRateTime;
	_increaseSpawnRateInterval = 0.2;
	_minSpawnRateTime = 0.3;


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
	killCount += 1;
	kill_count_changed.emit(killCount);
	var index = _zombies.find(zombie);
	
	if(index != -1):
		_zombies.remove_at(index);

func _characterDied(character: Character):
	for zombie in _zombies:
		zombie._remove_character(character);

func _getNewTarget(zombie: Zombie):
	var character = _characterSpawner._get_closest_character(zombie.global_position);
	zombie._setTarget(character);

func _onRestart():
	for zombie in _zombies:
		zombie.queue_free();
	
	_zombies.clear();

func _getKillCount() -> int:
	return killCount;

func _getSpawnLocation() -> Vector2:
	for i in spawnPoints.size():
		if(spawnPoints[spawnPointIndex].isAvailable):
			spawnPointIndex += 1;
			spawnPointIndex %= spawnPoints.size();
			return spawnPoints[spawnPointIndex].global_position;
		else:
			spawnPointIndex += 1;
			spawnPointIndex %= spawnPoints.size();
	
	return Vector2.ZERO;
