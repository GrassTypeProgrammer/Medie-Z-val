extends CharacterBody2D


var _direction: Vector2;
var _ready: bool = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(_ready):
		self.rotation = Vector2(0, -1).angle_to(_direction);
		var _velocity = _direction * delta *20;
		var collision = move_and_collide(_velocity);


func _set_direction(direction:Vector2):
	_direction = direction;
	_ready = true;
