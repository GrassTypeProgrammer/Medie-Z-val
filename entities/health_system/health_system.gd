extends Node2D


var _health: float = 20;

signal on_death;

func _take_damage(damage: float):
	_health -= damage;
	if(_health <= 0):
		on_death.emit();
