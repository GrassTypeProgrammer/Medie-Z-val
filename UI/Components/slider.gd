extends Node2D

signal _drag_ended(value_changed: bool);

# Called when the node enters the scene tree for the first time.
func _ready():
	$HSlider.drag_ended.connect(_on_drag_ended)



func _on_drag_ended(value_changed: bool):
	_drag_ended.emit(value_changed);
