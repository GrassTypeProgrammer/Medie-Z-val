extends Node2D


#Types
const Character = preload("res://player_character/player_character.gd");
const Zombie = preload("res://enemies/zombie/zombie.gd");
const CharacterSpawner = preload("res://character_controller/character_controller.gd");
const SpawnPoint = preload("res://enemies/zombie_spawner/SpawnPoint/spawn_point.gd");
const ZombieSpawner = preload("res://enemies/zombie_spawner/zombie_spawner.gd");
const HealthSystem = preload("res://entities/health_system/health_system.gd");


#Scenes
const ZombieScene = preload("res://enemies/zombie/zombie.tscn");
const CharacterScene = preload("res://player_character/player_character.tscn");
const ArrowScene = preload("res://Ammo/arrow/arrow.tscn");

#Levels
const MainMenu = preload("res://levels/main_menu/main_menu.tscn");
const Level1 = preload("res://levels/zombie_test_level/zombie_test_scene.tscn");
