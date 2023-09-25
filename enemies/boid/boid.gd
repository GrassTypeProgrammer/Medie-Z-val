extends CharacterBody2D


var _screen_turn_multiplier: float = 0.1;
var _seperation_multiplier: float = 0.1;
var _alignment_multiplier: float = 0.1;
var _cohesion_multiplier: float = 0.05;
var _separation_distance: int = 30;

func _set_screen_turn_multiplier(value:float):
	_screen_turn_multiplier = value;

func _set_seperation_multiplier(value:float):
	_seperation_multiplier = value;

func _set_alignment_multiplier(value:float):
	_alignment_multiplier = value;
	
func _set_cohesion_multiplier(value:float):
	_cohesion_multiplier = value;
	
func _set_seperation_distance(value:int):
	_separation_distance = value;


@onready var _height: int = ProjectSettings.get_setting("display/window/size/viewport_height");
@onready var _width: int = ProjectSettings.get_setting("display/window/size/viewport_width");



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
	
	print();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	velocity = _direction.normalized() * _speed;
	self.rotation = Vector2(0, -1).angle_to(_direction);
	_velocity = _direction * _speed * delta;
	var collision: KinematicCollision2D = move_and_collide(_velocity );
	_direction = _get_flock_direction();

func _get_velocity()->Vector2:
	return _velocity;

func _collision_reaction_direction(collision: KinematicCollision2D):
	var n = collision.get_normal();
	var u = (_velocity.dot(n) / n.dot(n)) * n;
	var w = _velocity  - u;
	var newDirection = (w-u).normalized();
	return newDirection;

func _set_direction(direction: Vector2):
	_direction = direction;



func _get_flock_direction()->Vector2:
	var screen_turn = _get_screen_turn_factor();
	var cohesion = Vector2();
	var seperation = Vector2();
	var alignment = Vector2();
	
	for boid in _neighbours:
		alignment += boid._get_velocity();
		cohesion += boid.global_position;
		
		if((boid.global_position - self.global_position).length() < 40):
			seperation += self.global_position - boid.global_position;
	
	if(_neighbours.size()):
		cohesion /= _neighbours.size();
		alignment /= _neighbours.size();
	
	screen_turn = screen_turn.normalized() *_screen_turn_multiplier;
	seperation = seperation.normalized() * _seperation_multiplier;
	alignment = alignment.normalized() * _alignment_multiplier;
	cohesion = cohesion.normalized() * _cohesion_multiplier;
	return (_direction + screen_turn + seperation + alignment + cohesion).normalized();
	

func _get_screen_turn_factor()->Vector2:
	var screen_turn_factor = Vector2();
	
	if(self.global_position.x < 100):
		screen_turn_factor += Vector2.RIGHT;
	elif(self.global_position.x > _width-100):
		screen_turn_factor += Vector2.LEFT;
	
	if(self.global_position.y < 100):
		screen_turn_factor += Vector2.DOWN;
	elif(self.global_position.y > _height-100):
		screen_turn_factor += Vector2.UP;
		
	return screen_turn_factor;

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
		_neighbours.append(area.owner);
	else:
		print('add Wall');
		_walls.append(area.owner);

func _remove_neighbour(area: Area2D):
	if(area.owner.is_in_group('boid')):
		var index = _neighbours.find(area.owner);
		if(index != -1):
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
