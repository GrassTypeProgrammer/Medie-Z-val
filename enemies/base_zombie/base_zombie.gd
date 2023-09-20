extends CharacterBody2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)
var targetCharacter;
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
signal needsNewTarget;


func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	
	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
#	targetCharacter = (get_parent() as enemy_manager)._get_new_target(position);

	# Now that the navigation map is no longer empty, set the movement target.
	needsNewTarget.emit(self);
	

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if(targetCharacter == null):
		needsNewTarget.emit(self);
		return;
	
	
	if navigation_agent.is_navigation_finished():
		return
	
	set_movement_target(targetCharacter.position);
	
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	velocity = new_velocity
	move_and_slide()


func _set_new_target(newTarget):
	targetCharacter = newTarget;
	set_movement_target(targetCharacter.position);


