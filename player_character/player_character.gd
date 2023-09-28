extends CharacterBody2D

var destination: Vector2;
var direction: Vector2;
var moving: bool = false;
const speed: int = 200;
var index: int;
var arrow_scene = preload("res://Ammo/arrow/arrow.tscn");
@onready var _area: Area2D = $DetectionArea;

var _zombies:Array = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	print('Awake: ');
	print(index);
	
	
	
	_area.body_entered.connect(_detect_zombie);
	_area.body_exited.connect(_on_collision_exit);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(moving):
		_move_to_destination(delta);


func _spawn_arrow():
	var arrow = arrow_scene.instantiate();
	arrow.global_position = self.global_position + (_zombies[0].global_position - self.global_position).normalized() * 50;
	arrow._set_direction((_zombies[0].global_position - self.global_position).normalized());
	get_tree().root.call_deferred('add_child', arrow);



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
		_spawn_arrow();
		print('Zombie!!!');

func _on_collision_exit(body: Node2D):
	if( body.is_in_group('Zombie')):
		var index = _zombies.find(body);
		if(index != -1):
			_zombies.remove_at(index);
			print('Zombie Leave!!!');
