extends Node2D

var _boid_scene = preload("res://enemies/boid/boid.tscn");
var _timer: float;
var _spawnTime: float = .1;
var _counter: int = 0;
var _max_count: int = 50;
var _boids: Array = [];

func _ready():
	_timer = _spawnTime;
	$SeperationSlider._value_changed.connect(_change_seperation_value);
	$CohesionSlider._value_changed.connect(_change_cohesion_value);
	$AlignmentSlider._value_changed.connect(_change_alignment_value);
	$SeperationDistanceSlider._value_changed.connect(_change_seperation_distance_value);
	$ScreenAvoidanceSlider._value_changed.connect(_change_screen_avoidance_value);
	$SpeedSlider._value_changed.connect(_change_speed_value);
	
func _process(delta):
	_timer -= delta;
	
	if(_counter < _max_count && _timer <= 0):
		_timer = _spawnTime;
		var boid = _boid_scene.instantiate();
		boid.global_position = Vector2(500, 300);
		_boids.append(boid);
		add_child(boid);
		_counter+= 1;

func _change_seperation_value(value_changed: bool):
	if(value_changed):
		for boid in _boids:
			boid._set_seperation_multiplier($SeperationSlider._get_value());

func _change_cohesion_value(value_changed: bool):
	if(value_changed):
		for boid in _boids:
			boid._set_cohesion_multiplier($CohesionSlider._get_value());

func _change_alignment_value(value_changed: bool):
	if(value_changed):
		for boid in _boids:
			boid._set_alignment_multiplier($AlignmentSlider._get_value());

func _change_seperation_distance_value(value_changed: bool):
	if(value_changed):
		for boid in _boids:
			boid._set_seperation_distance($SeperationDistanceSlider._get_value());

func _change_screen_avoidance_value(value_changed: bool):
	if(value_changed):
		for boid in _boids:
			boid._set_screen_turn_multiplier($ScreenAvoidanceSlider._get_value());

func _change_speed_value(value_changed: bool):
	if(value_changed):
		for boid in _boids:
			boid._set_speed($SpeedSlider._get_value());
