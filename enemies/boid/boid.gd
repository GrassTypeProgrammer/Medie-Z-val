extends CharacterBody2D


@export var _seperation_bias: float = 0.5;
@export var _heading_bias: float = 0.5;
@export var _cohesion_bias: float = 0.1;
@export var _separation_distance: int = 30;

@export var _direction_right: bool;
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D;
@onready var _sprite: Sprite2D = $Sprite2D;

enum State {Chasing, Following, Roaming}
var _state: State = State.Chasing;

static var nextID:int = 0;
var ID: int;

var _direction: Vector2;
var _velocity: Vector2;
var _speed: int = 200;
var _max_speed: int = 200;

@onready var _area: Area2D = $DetectionArea;
#var _boid_scene = preload("res://enemies/boid/boid.tscn");
var _neighbours:Array = [];

var _following: bool = false;
var _tier: int = 0;

var _walls:Array = [];
var _wall_avoidance: Vector2;

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new();
	ID = nextID;
	nextID+= 1;
	_set_direction(Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized());
#	_set_direction(Vector2.UP);
	_area.area_entered.connect(_detected_neighbour);
	_area.area_exited.connect(_remove_neighbour);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	velocity = _direction.normalized() * _speed;
	_set_state();
	self.rotation = Vector2(0, -1).angle_to(_direction);
	
	
	_velocity = _direction.normalized() * _speed * delta;
	var collision: KinematicCollision2D = move_and_collide(_velocity );
	
#	if(collision):
#		_direction = _collision_reaction_direction(collision);
#	else:
#		_direction = _get_flock_direction();
	var wall_separation = Vector2();
	var multiplier:float;
	
#	if(_walls.size() > 0):
#		for wall in _walls:
#			wall_separation += (wall.global_position - self.global_position).normalized();
#			multiplier = (wall.global_position - self.global_position).length() *0.5;
#
#		wall_separation/= _walls.size();
#
#	wall_separation *= 1;
	if(_tier == 0):
		
		navigation_agent.target_position = get_global_mouse_position();
		var next_path_position: Vector2 = navigation_agent.get_next_path_position() + Vector2();
		_direction = (next_path_position - self.global_position).normalized();
		
	else:
		print(_walls.size());
		_direction = _get_flock_direction();
#elif(_state == State.Chasing):
#	navigation_agent.target_position = get_global_mouse_position();
#	var next_path_position: Vector2 = navigation_agent.get_next_path_position() + Vector2();
#	_direction = (next_path_position - self.global_position).normalized();
#	elif(_state == State.Roaming):
#		_direction == Vector2(0, 0);

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
		if(neighbour._get_tier() <= _tier):
			heading += neighbour._get_direction(); 

		cohesion += neighbour.global_position; 
		
		var distance = self.global_position.distance_to(neighbour.global_position);
			
		if(distance < _separation_distance):
			separation -= (neighbour.global_position - self.global_position).normalized() * (_separation_distance / distance *_speed);
	
	if _neighbours.size()>0:
		heading /= _neighbours.size();
		cohesion /= _neighbours.size();
		var center_direction = self.global_position.direction_to(cohesion);
		var center_speed = _max_speed * self.global_position.distance_to(cohesion)/$DetectionArea/CollisionShape2D.shape.radius;
		cohesion = center_direction * center_speed;
	
	var mouse2 = get_global_mouse_position() - self.global_position;
	mouse2.normalized();
	heading += mouse2;
	
	var wall_separation = Vector2();
	if(_walls.size() > 0):
		for wall in _walls:
			wall_separation += (wall.global_position - self.global_position).normalized();
		
		wall_separation/= _walls.size();
	
	wall_separation *= 1;
	separation *= _seperation_bias;
	heading *= _heading_bias;
	cohesion *= _cohesion_bias;
#	return (separation *0.5 + heading * 0.5 + cohesion * 0.1).clamp(Vector2(-_max_speed, -_max_speed),Vector2(_max_speed, _max_speed));
#	return (mouse2 + separation *0.5 + heading * 0.5 + cohesion * 0.1).clamp(Vector2(-_max_speed, -_max_speed),Vector2(_max_speed, _max_speed));
#	return (mouse2 + separation  + heading  + cohesion ).clamp(Vector2(-_max_speed, -_max_speed),Vector2(_max_speed, _max_speed));
	return ( (separation  + heading  + cohesion )).clamp(Vector2(-_max_speed, -_max_speed),Vector2(_max_speed, _max_speed));
	

func _set_state():
	var distance_to_target = (get_global_mouse_position() - self.global_position).length();
	
	
	
	if(_neighbours.size() == 0):
		_tier = 0;
		return;
	
	var closest:bool = true;
	var lowest_tier_neighbour:int = -1;
	
	for neighbour in _neighbours:
		if(neighbour._get_tier() == -1):
			continue;
			
		var neighbour_distance = (get_global_mouse_position() - neighbour.global_position).length();
		if(neighbour_distance < distance_to_target):
			closest = false;
			if(lowest_tier_neighbour == -1||neighbour._get_tier() < lowest_tier_neighbour):
				lowest_tier_neighbour = neighbour._get_tier() ;
	
	
	if(closest):
		_tier = 0;
		_sprite.modulate= Color(1,0,0, 1);
	else:
		_tier = lowest_tier_neighbour +1;
		_sprite.modulate= Color(0,0,1, 1);
	
#	print('tier: ' + str(_tier));

func _get_direction()->Vector2:
	return _direction;

func _detected_neighbour(area: Area2D ):
	if(area.owner.is_in_group('boid')):
		print('add Neighbour');
		_neighbours.append(area.owner);
	else:
		print('add Wall');
		_walls.append(area.owner);

func _remove_neighbour(area: Area2D):
	if(area.owner.is_in_group('boid')):
		var index = _neighbours.find(area.owner);
		if(index != -1):
			print('remove Neighbour');
			_neighbours.remove_at(index);
	else:
		var index = _walls.find(area.owner);
		if(index != -1):
			print('remove Wall');
			_walls.remove_at(index);

func _get_is_following()->bool:
	return _following;


func _get_state()->State:
	return _state;

func _get_tier()->int:
	return _tier;
