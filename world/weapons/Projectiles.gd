extends Node2D

const BULLET_BASE = preload("res://world/weapons/BulletBase.tscn")

func _ready():
	GameData.projectiles = self



func spawnSword(pos: Vector2, direction: Vector2) -> void:
	var bullet = BULLET_BASE.instance()
	
	add_child(bullet)
	bullet.shoot(bullet.BulletTypes.Sword, pos, direction)