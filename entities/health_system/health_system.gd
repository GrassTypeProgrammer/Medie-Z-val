extends Node2D

@onready var background: Control = $Background;
@onready var foreground: Control = $Background/Foreground;
var _maxHealthBarSize: int;
var _healthBarSize: int;
var _maxHealth: float = 20;
var _health: float = _maxHealth;

signal on_death;

func _ready():
	_maxHealthBarSize = int(foreground.size.x);
	_healthBarSize = _maxHealthBarSize;
	global_rotation = 0;


func _take_damage(damage: float):
	_health -= damage;
	
	if(_health < 0):
		_health = 0;
	elif(_health > _maxHealth):
		_health = _maxHealth;
	
	_updateHealthBar();
	
	if(_health <= 0):
		on_death.emit();


func _updateHealthBar():
	if(_health < _maxHealth):
		background.visible = true;
	else:
		background.visible = false;
		
	var healthBarPercentage = (_health/_maxHealth);
	_healthBarSize = int(_maxHealthBarSize * healthBarPercentage);
	foreground.size = Vector2(_healthBarSize, foreground.size.y);
