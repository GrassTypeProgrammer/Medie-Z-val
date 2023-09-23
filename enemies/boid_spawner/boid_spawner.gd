extends Node2D

var _boid_scene = preload("res://enemies/boid/boid.tscn");
var _timer: float;
var _spawnTime: float = .1;
var _counter: int = 0;

func _ready():
	_timer = _spawnTime;


func _process(delta):
	_timer -= delta;
	
	if(_counter < 25 && _timer <= 0):
		_timer = _spawnTime;
		var boid = _boid_scene.instantiate();
		add_child(boid);
		_counter+= 1;
