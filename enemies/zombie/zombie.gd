extends CharacterBody2D


var _screen_turn_multiplier: float = 0.1;
var _seperation_multiplier: float = 0.1;
var _alignment_multiplier: float = 0.1;
var _cohesion_multiplier: float = 0.05;
var _bias_multiplier: float = 0.03;
var _separation_distance: int = 30;
var _speed: int = 50;

func _set_screen_turn_multiplier(value:float):
	_screen_turn_multiplier = value;

func _set_seperation_multiplier(value:float):
	_seperation_multiplier = value;

func _set_alignment_multiplier(value:float):
	_alignment_multiplier = value;
	
func _set_cohesion_multiplier(value:float):
	_cohesion_multiplier = value;

func _set_bias_multiplier(value:float):
	_bias_multiplier = value;

func _set_seperation_distance(value:int):
	_separation_distance = value;

func _set_speed(value:int):
	_speed = value;

@onready var _height: int = ProjectSettings.get_setting("display/window/size/viewport_height");
@onready var _width: int = ProjectSettings.get_setting("display/window/size/viewport_width");
@onready var _sprite: Sprite2D = $Sprite2D;
@onready var _area: Area2D = $DetectionArea;

const HealthSystem = preload("res://entities/health_system/health_system.gd");
@onready var _health_system: HealthSystem = $HealthSystem;

func _get_health_system() -> HealthSystem:
	return _health_system;

var _direction: Vector2;
var _velocity: Vector2;
var _neighbours:Array = [];
var _wall_avoidance: Vector2;

var _player_characters_detected_by: Array = [];



# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new();
	_set_direction(Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized());
	_area.area_entered.connect(_detected_neighbour);
	_area.area_exited.connect(_remove_neighbour);
	_health_system.on_death.connect(_on_death);
	


func _physics_process(_delta):
	self.rotation = Vector2(0, -1).angle_to(_direction);
	_velocity = _direction * _speed ;
	velocity = _velocity;
#	var collision: KinematicCollision2D = move_and_collide(_velocity );
	move_and_slide();
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
	var bias = Vector2();
	
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
	bias = (get_global_mouse_position() - self.global_position).normalized() * _bias_multiplier;
	return (_direction + screen_turn + seperation + alignment + cohesion + bias).normalized();


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


func _get_direction()->Vector2:
	return _direction;


func _detected_neighbour(area: Area2D ):
	if(area.owner.is_in_group('boid')):
		_neighbours.append(area.owner);


func _remove_neighbour(area: Area2D):
	if(area.owner.is_in_group('boid')):
		var index = _neighbours.find(area.owner);
		if(index != -1):
			_neighbours.remove_at(index);

func _add_player(character: CharacterBody2D):
	if(!_player_characters_detected_by.find(character)):
		_player_characters_detected_by.append(character);

func _remove_player(character: CharacterBody2D):
	var index = _player_characters_detected_by.find(character);
	if(index != -1):
		_player_characters_detected_by.remove_at(index);

func _on_death():
	for character in _player_characters_detected_by:
			character._remove_zombie(self);
	self.queue_free();

