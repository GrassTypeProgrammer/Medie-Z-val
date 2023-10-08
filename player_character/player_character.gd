extends CharacterBody2D

#Types
const Zombie = preload("res://enemies/zombie/zombie.gd");
const HealthSystem = preload("res://entities/health_system/health_system.gd");

#scenes
const arrow_scene = preload("res://Ammo/arrow/arrow.tscn");

#onready
@onready var _area: Area2D = $DetectionArea;
@onready var _navAgent: NavigationAgent2D = $NavigationAgent2D;
@onready var _health_system: HealthSystem = $HealthSystem;

var destination: Vector2;
var direction: Vector2;
var moving: bool = false;
const speed: int = 200;
var _index: int;

var _zombies:Array = [];

var _reload_time: float = 1;
var _reload_timer: float = _reload_time;
var _can_fire_arrow: float = true;


func _get_health_system() -> HealthSystem:
	return _health_system;


signal on_death;

# Called when the node enters the scene tree for the first time.
func _ready():
	_area.body_entered.connect(_detect_zombie);
	_area.body_exited.connect(_on_collision_exit);
	_health_system.on_death.connect(_on_death);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(moving):
		_move_to_destination(delta);
		
	if(!_can_fire_arrow ):
		if(_reload_timer > 0):
			_reload_timer -= delta;
		else:
			_reload_timer = _reload_time;
			_can_fire_arrow = true;
			
	
	
#	if(_zombies.size() > 0 &&_can_fire_arrow):
#		_spawn_arrow();
	


func _spawn_arrow():
	var arrow = arrow_scene.instantiate();
	arrow.global_position = self.global_position + (_zombies[0].global_position - self.global_position).normalized() * 50;
	arrow._set_direction((_zombies[0].global_position - self.global_position).normalized());
	get_tree().root.call_deferred('add_child', arrow);
	_can_fire_arrow = false;



func _set_destination(new_destination: Vector2):
	_navAgent.target_position = new_destination;
	moving = true;


func _move_to_destination(delta):
	velocity =  (_navAgent.get_next_path_position()-global_position).normalized() * speed;
	move_and_slide();
	
	if(_navAgent.distance_to_target() < 5):
		moving = false;


func _detect_zombie(body: Node2D):
	if( body.is_in_group('Zombie')):
		_zombies.append((body));
		print('Zombie!!!');


func _on_collision_exit(body: Node2D):
	if( body.is_in_group('Zombie')):
		var index = _zombies.find(body);
		if(index != -1):
			_zombies.remove_at(index);
			print('Zombie Leave!!!');


func _remove_zombie(zombie: Zombie):
	var index = _zombies.find(zombie);
	if(index != -1):
		_zombies.remove_at(index);
		print(_zombies.size());


func _on_death():
	on_death.emit(self);
	self.queue_free();
