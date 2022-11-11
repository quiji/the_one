extends CanvasLayer

signal faded_out
signal faded_in

onready var anims = $anims

func _ready() -> void:
	
	anims.connect("animation_finished", self, "_on_anim_finished")

func change_scene(path: String) -> void:
	anims.play("fade_out")
	yield(anims, "animation_finished")
	get_tree().change_scene(path)
	anims.play("fade_in")
	yield(anims, "animation_finished")

	


func _on_anim_finished(anim_name: String) -> void:
	match anim_name:
		"fade_out":
			emit_signal("faded_out")
		"fade_in":
			emit_signal("faded_in")


func fade_out() -> void:
	anims.play("fade_out")
	
func fade_in() -> void:
	anims.play("fade_in")
	
