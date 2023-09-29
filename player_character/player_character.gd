extends CharacterBody2D

var destination: Vector2;
var direction: Vector2;
var moving: bool = false;
const speed: int = 200;
var _index: int;
var arrow_scene = preload("res://Ammo/arrow/arrow.tscn");
@onready var _area: Area2D = $DetectionArea;

var _zombies:Array = [];

var _reload_time: float = 1;
var _reload_timer: float = _reload_time;
var _can_fire_arrow: float = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	print('Awake: ');
	print(_index);
	
	
	
	_area.body_entered.connect(_detect_zombie);
	_area.body_exited.connect(_on_collision_exit);

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
			
	
	
	if(_zombies.size() > 0 &&_can_fire_arrow):
		_spawn_arrow();


func _spawn_arrow():
	var arrow = arrow_scene.instantiate();
	arrow.global_position = self.global_position + (_zombies[0].global_position - self.global_position).normalized() * 50;
	arrow._set_direction((_zombies[0].global_position - self.global_position).normalized());
	get_tree().root.call_deferred('add_child', arrow);
	_can_fire_arrow = false;



func _set_destination(new_destination: Vector2):
	destination = new_destination;
	direction =  position.direction_to(new_destination);
	moving = true;

func _move_to_destination(delta):
	position += direction * delta * speed;
		
	if(position.distance_to(destination) < 10):
#		print(position.distance_to(destination));
		moving = false;

func _detect_zombie(body: Node2D):
	if( body.is_in_group('Zombie')):
		_zombies.append((body));
		body._add_player(self);
		print('Zombie!!!');

func _on_collision_exit(body: Node2D):
	if( body.is_in_group('Zombie')):
		var index = _zombies.find(body);
		if(index != -1):
			_zombies[index]._remove_player(self);
			_zombies.remove_at(index);
			print('Zombie Leave!!!');

func _remove_zombie(body: Node2D):
	var index = _zombies.find(body);
	if(index != -1):
		_zombies.remove_at(index);
		print(_zombies.size());
