tool
extends AnimationPlayer

signal action_finished(action_name)
signal reacted(action_name, reaction)

export (Array, String) var unloop_anims 
export (Array, Dictionary) var reactions
export (bool) var update_anims = false setget set_update_anims



func _ready():
	#connect("animation_finished", self, "_on_animation_finished")
	
	if not Engine.editor_hint:
		for i in range(unloop_anims.size()):
		
			if has_animation(unloop_anims[i]):
				add_user_signal("action_" + unloop_anims[i] + "_finished")



func set_update_anims(do_we: bool) -> void:
	if not do_we:
		return
	
	for i in range(unloop_anims.size()):
		
		if has_animation(unloop_anims[i]):
			var anim = get_animation(unloop_anims[i])
			
			anim.loop = false
			
			var track_id = anim.add_track(Animation.TYPE_METHOD)
			anim.track_set_path(track_id, "./anims")
			anim.track_insert_key(track_id, anim.length, {method = "_on_action_finished", args = [unloop_anims[i]] })

	for i in range(reactions.size()):
		
		if has_animation(reactions[i].anim):
			var anim = get_animation(reactions[i].anim)
			
			var track_id = anim.add_track(Animation.TYPE_METHOD)
			anim.track_set_path(track_id, "./anims")
			anim.track_insert_key(track_id, reactions[i].time, {method = "_on_reaction", args = [reactions[i].anim, reactions[i].reaction] })
	
	
	
func _on_reaction(anim: String, reaction: String) -> void:
	emit_signal("reacted", anim, reaction)

func _on_action_finished(action_name: String) -> void:

	emit_signal("action_finished", action_name)
	emit_signal("action_" + action_name + "_finished")


