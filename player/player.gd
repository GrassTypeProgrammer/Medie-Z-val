extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction: Vector2 = Vector2();
	
	if(Input.is_action_pressed("Up")):
		direction += Vector2.UP;
	elif(Input.is_action_pressed("Down")):
		direction += Vector2.DOWN;
	
	if(Input.is_action_pressed("Right")):
		direction += Vector2.RIGHT;
	elif(Input.is_action_pressed("Left")):
		direction += Vector2.LEFT;
	
	velocity = direction.normalized() * 200;
	move_and_slide();
