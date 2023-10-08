extends CharacterBody2D

const Character = preload("res://player_character/player_character.gd");
var _seperation_multiplier: float = 1;
var _speed: int = 150;
var _separation_distance: int = 70;



@onready var _area: Area2D = $DetectionArea;
@onready var _navAgent: NavigationAgent2D = $NavigationAgent2D;

const HealthSystem = preload("res://entities/health_system/health_system.gd");
@onready var _health_system: HealthSystem = $HealthSystem;

func _get_health_system() -> HealthSystem:
	return _health_system;

var _direction: Vector2;
var _velocity: Vector2;
var _neighbours:Array = [];
var _wall_avoidance: Vector2;

#character that the zombie has detected
var _player_characters: Array[Character] =[];

static var nextID = 1;
var ID;

var _attack_time: float = 0.5;
var _attack_timer:float = 0;

signal on_death;
signal needs_new_target;

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new();
	_set_direction(Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized());
#	_area.area_entered.connect(_detected_neighbour);
	_area.area_exited.connect(_remove_neighbour);
	_health_system.on_death.connect(_on_death);
	_navAgent.avoidance_enabled = true;
	_navAgent.velocity_computed.connect(_safe_velocity_computed);
	ID = nextID;
	nextID+=1;
	_navAgent.radius = 30;
	needs_new_target.emit(self);
	
	if(ID != 1):
		_navAgent.debug_enabled = false;


func _safe_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity;
	move_and_slide();


func _physics_process(delta):
	self.rotation = Vector2(0, -1).angle_to(_direction);
	
	if(_player_characters.size() > 0 &&
	 self.global_position.distance_to(_player_characters[0].global_position) < 70):
		pass;
		_attack(delta);
	else:
		_movement();


func _attack(delta: float):
	if(_attack_timer > 0):
		_attack_timer -= delta;
	else:
		_attack_timer = _attack_time;
		_player_characters[0]._health_system._take_damage(10);
		print('attack');


func _movement():
	if(_player_characters.size() > 0):
		_navAgent.target_position = _player_characters[0].global_position;
	
	var seperation = Vector2();
	for boid in _neighbours:
		
		if((boid.global_position - self.global_position).length() < 40):
			seperation += self.global_position - boid.global_position;
	
	seperation = seperation.normalized() * _seperation_multiplier;
	
	_velocity = (_direction + seperation )* _speed ;

	velocity = _velocity;
	_navAgent.set_velocity(velocity);
	_direction = (_navAgent.get_next_path_position() - global_position).normalized();


func _set_direction(direction: Vector2):
	_direction = direction;

func _get_player_direction()->Vector2:
	var direction = Vector2();
	
	if(_player_characters.size() > 0):
		direction = (_player_characters[0].global_position - self.global_position).normalized();
	
	return direction;



func _get_direction()->Vector2:
	return _direction;


func _setTarget(character: Character):
	_player_characters.append(character);
#func _detected_neighbour(area: Area2D ):
#	if(area.owner.is_in_group('PlayerCharacter')):
#		_player_characters.append(area.owner);


func _remove_neighbour(area: Area2D):
	if(area.owner.is_in_group('PlayerCharacter')):
		var index = _player_characters.find(area.owner);
		if(index != -1):
			_player_characters.remove_at(index);

func _remove_character(character: Character):
	var index = _player_characters.find(character);
	if(index != -1):
		_player_characters.remove_at(index);
		if(_player_characters.size() == 0):
			needs_new_target.emit(self);


func _on_death():
	on_death.emit(self);
	self.queue_free();
