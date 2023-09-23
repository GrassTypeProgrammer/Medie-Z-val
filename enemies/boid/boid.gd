extends CharacterBody2D

@export var _direction_right: bool;

static var nextID:int = 0;
var ID: int;

var _direction: Vector2;
var _velocity: Vector2;
var _speed: int = 200;
var _separation_distance: int = 40;
var _max_speed: int = 200;

@onready var _area: Area2D = $DetectionArea;
#var _boid_scene = preload("res://enemies/boid/boid.tscn");
var _neighbours:Array = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new();
	ID = nextID;
	nextID+= 1;
	_set_direction(Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized());
	_area.area_entered.connect(_detected_neighbour);
	_area.area_exited.connect(_remove_neighbour);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	velocity = _direction.normalized() * _speed;
	self.rotation = Vector2(0, -1).angle_to(_direction);
	_velocity = _direction.normalized() * _speed * delta;
	var collision: KinematicCollision2D = move_and_collide(_velocity );
	
	if(collision):
		var collider = collision.get_collider();
		if(collider.is_in_group('boid')):
			print('boid');
		_direction = _collision_reaction_direction(collision);
	else:
		_direction = _get_flock_direction();
	

func _collision_reaction_direction(collision: KinematicCollision2D):
	var n = collision.get_normal();
	var u = (_velocity.dot(n) / n.dot(n)) * n;
	var w = _velocity  - u;
	var newDirection = (w-u).normalized();
	return newDirection;

func _set_direction(direction: Vector2):
	_direction = direction;

func _get_flock_direction()->Vector2:
	var separation = Vector2();
	var heading = _direction;
	var cohesion = Vector2();
	
	for neighbour in _neighbours:
		heading += neighbour._get_direction();
		cohesion += neighbour.position;
		
		var distance = self.position.distance_to(neighbour.position);
			
		if(distance < _separation_distance):
			separation -= (neighbour.position - self.position).normalized() * (_separation_distance / distance *_speed);
	
	if _neighbours.size()>0:
		heading /= _neighbours.size();
		cohesion /= _neighbours.size();
		var center_direction = self.position.direction_to(cohesion);
		var center_speed = _max_speed * self.position.distance_to(cohesion)/$DetectionArea/CollisionShape2D.shape.radius;
		cohesion = center_direction * center_speed;
	
	return (_direction + separation *0.5 + heading * 0.5 + cohesion * 0.1).clamp(Vector2(-_max_speed, -_max_speed),Vector2(_max_speed, _max_speed));

func _detected_neighbour(area: Area2D ):
	if(area.owner.is_in_group('boid')):
		_neighbours.append(area.owner);

func _get_direction()->Vector2:
	return _direction;

func _remove_neighbour(area: Area2D):
	if(area.owner.is_in_group('boid')):
		var index = _neighbours.find(area.owner);
		if(index != -1):
			_neighbours.remove_at(index);
