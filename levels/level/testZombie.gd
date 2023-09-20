extends NavigationAgent2D

var thisRID;
var targetCharacter;


# Called when the node enters the scene tree for the first time.
func _ready():
	thisRID = NavigationServer2D.agent_create();
	NavigationServer2D.agent_set_position(thisRID, Vector2(-500, -500));
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	NavigationServer2D.
	pass;	
