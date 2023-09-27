extends CharacterBody2D

var destination: Vector2;
var direction: Vector2;
var moving: bool = false;
const speed: int = 200;
var index: int;
var arrow_scene = preload("res://Ammo/arrow/arrow.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	print('Awake: ');
	print(index);
	
	var arrow = arrow_scene.instantiate();
	arrow.global_position = Vector2(500, 200);
	arrow._set_direction(Vector2.RIGHT);
	get_tree().root.call_deferred('add_child', arrow);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(moving):
		_move_to_destination(delta);
	
	



func _set_destination(new_destination: Vector2):
	destination = new_destination;
	direction =  position.direction_to(new_destination);
	moving = true;

func _move_to_destination(delta):
	position += direction * delta * speed;
		
	if(position.distance_to(destination) < 10):
#		print(position.distance_to(destination));
		moving = false;
