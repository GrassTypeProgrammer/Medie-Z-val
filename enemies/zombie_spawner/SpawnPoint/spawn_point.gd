extends Node2D

@onready var _area: Area2D = $Area2D;

var isAvailable: bool = true;
var objects: Array = [];


# Called when the node enters the scene tree for the first time.
func _ready():
	_area.body_entered.connect(objectEnter);
	_area.body_exited.connect(objectLeave);

func _isAvailable() -> bool:
	return isAvailable;

func objectEnter(body: Node2D):
	objects.append(body);
	isAvailable = false;
	print(isAvailable);

func objectLeave(body: Node2D):
	var index = objects.find(body);
	if(index != -1):
		objects.remove_at(index);
		if(objects.size() == 0):
			isAvailable = true;
	print(isAvailable);
