extends Control

@onready var cM: CanvasModulate = $CanvasModulate;

# Called when the node enters the scene tree for the first time.
func _ready():
	cM.visible = true;

