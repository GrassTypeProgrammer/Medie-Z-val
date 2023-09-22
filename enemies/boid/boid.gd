extends CharacterBody2D

var _direction: Vector2;
var _speed: int = 200;
@onready var _area: Area2D = $DetectionArea;
#var _boid_scene = preload("res://enemies/boid/boid.tscn");
var _neighbours:Array = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_direction(Vector2.UP);
	_area.area_entered.connect(_detected_neighbour);
	_area.area_exited.connect(_remove_neighbour);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	velocity = _direction.normalized() * _speed;
	move_and_collide(_direction.normalized() * _speed * delta );


func _set_direction(direction: Vector2):
	_direction = direction;

func _detected_neighbour(area: Area2D ):
	if(area.is_in_group('boid')):
		_neighbours.append(area.owner);
		print(_neighbours.size());


func _remove_neighbour(area: Area2D):
	if(area.is_in_group('boid')):
		var index = _neighbours.find(area);
		if(index != -1):
			_neighbours.remove_at(index);
