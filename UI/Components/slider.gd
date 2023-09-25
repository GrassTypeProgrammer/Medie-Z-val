extends Node2D

@export var _min: float = 0;
@export var _max: float = 100;
@export var _value: float = 0;
@export var _label: String = 'Label';
@export var _step: float = 0.01;

var _dragging: bool = false;

signal _value_changed(value_changed: bool);

# Called when the node enters the scene tree for the first time.
func _ready():
#	$HSlider.drag_ended.connect(_on_drag_ended);
	$HSlider.drag_started.connect(_on_drag_started);
	$HSlider.min_value = _min;
	$HSlider.max_value = _max;
	$HSlider.step = _step;
	$HSlider.value = _value;
	$value.text = str($HSlider.value);
	$label.text = _label;
	

func _process(delta):
	if(_dragging && $HSlider.value_changed):
		_value_changed.emit($HSlider.value);
		$value.text=(str($HSlider.value));


func _on_drag_started():
	_dragging = true;

func _on_drag_ended(value_changed: bool):
	_dragging = false;
#	_drag_ended.emit(value_changed);
#	$value.text=(str($HSlider.value));

func _get_value():
	return $HSlider.value;

