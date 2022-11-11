tool
extends AnimationPlayer

signal action_finished(action_name)

export (Resource) var aseprite_data setget set_aseprite_data

func _ready():
	if not Engine.editor_hint:

		var animation_list = get_animation_list()

		for anims in animation_list:
			var anim_res = get_animation(anims)
			if not anim_res.loop:
				add_user_signal("action_" + anims + "_finished")

				var track_id = anim_res.add_track(Animation.TYPE_METHOD)
				anim_res.track_set_path(track_id, "./" + name)
				anim_res.track_insert_key(track_id, anim_res.length, {method = "_on_action_finished", args = [anims, get_parent()] })

	
func _on_action_finished(action_name: String, who) -> void:

	if who != get_parent():
		return 
		
	emit_signal("action_finished", action_name)
	emit_signal("action_" + action_name + "_finished")


func _execute(actions) -> void:

	for action in actions:

		for key in action:
			if not has_node(key):
				continue
			
			var action_node = get_node(key)
			var current_action = action[key]

			
			if current_action.has('call'):
				# its a method
				action_node.call(current_action.call)
			elif current_action.has('set') and current_action.has('to') and action_node.get(current_action.set) != null:
				# its a property
				action_node.set(current_action.set, current_action.to)



#####################################################################################################################
# 
# Editor Plugin Logic
#
#####################################################################################################################

func set_aseprite_data(res: Resource) -> void:

	aseprite_data = res

	if not aseprite_data:
		_nuke_anims()
		

func check_updates():
	
	if not aseprite_data: return
	
	var AseResourceUpdates = preload('res://addons/asepriteAnimationResource/updates.gd').new()

	if AseResourceUpdates.is_updated(aseprite_data.anims_path):
		
		print("Updating animations!")


		_nuke_anims()

		for anim in aseprite_data.animation_list:
			print("adding ", anim)
			add_animation(anim, load(aseprite_data.anims_path + '/' + anim + '.anim'))
		
		AseResourceUpdates.set_updated(aseprite_data.anims_path, false)
		AseResourceUpdates.save()

		return {
			anims = aseprite_data.animation_filenames,
			dir = aseprite_data.anims_path
		}
	
	return null

func _nuke_anims():

	var animation_list = get_animation_list()
	for anim in animation_list:

		remove_animation(anim)
