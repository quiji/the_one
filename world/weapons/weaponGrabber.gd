extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_onPlayerEntered")


func _onPlayerEntered(who) -> void:

	who.equip("sword")

	queue_free()