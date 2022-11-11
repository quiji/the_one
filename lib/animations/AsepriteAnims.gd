tool
extends AnimationPlayer

class_name AsepriteAnimPlayer

signal action_finished(action_name)

export (NodePath) var sprite_node
export (PoolStringArray) var unloop_anims 
export (bool) var update_anims = false setget set_update_anims


var defaultOffset = Vector2(0,0)


func _ready():
	pass

func set_update_anims(do_we: bool) -> void:
	
	if not do_we:
		return
	
	

	if not has_node(sprite_node):
		print("Sprite Node is required")
		return

	clear_animations()

	var sprite = get_node(sprite_node)

	if sprite.texture == null:
		print("The assigned sprite has no texture")
		return

	var path = sprite.texture.resource_path.split(".")
	path[path.size()-1] = "json"
	path = path.join(".")

	
	var file = File.new()
	if not file.file_exists(path):
		print("Aseprite Anim: No JSON file!")
		return

	if file.open(path, File.READ) != 0:
		print("Aseprite Anim: Error opening JSON file")
		return

	var data_text = file.get_as_text()
	file.close()

	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		print("Aseprite Anim: JSON parsing error")
		return

	var spriteanim = data_parse.result
	var framesize: Vector2

	var temporal_frames = spriteanim.frames.values()
	framesize.y = temporal_frames[0].sourceSize.h
	framesize.x = temporal_frames[0].sourceSize.w

	#sprite.vframes = sprite.texture.get_height()/framesize.y
	#sprite.hframes = sprite.texture.get_width()/framesize.x
	sprite.vframes = 1
	sprite.hframes = 1
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0, 0, framesize.x * sprite.hframes, framesize.y * sprite.vframes)

	for tag in spriteanim["meta"]["frameTags"]:
		var startFrame = tag["from"]
		var endFrame = tag["to"]
		var animName = tag["name"]
		
		var anim = Animation.new()
		add_animation(animName, anim)
		anim.loop = true
		anim.add_track(Animation.TYPE_VALUE)
		anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_interpolation_type(0, Animation.INTERPOLATION_NEAREST)
		anim.track_set_interpolation_type(1, Animation.INTERPOLATION_NEAREST)
		#anim.track_set_path(0, sprite.name + ":frame")
		anim.track_set_path(0, sprite.name + ":region_rect")
		anim.track_set_path(1, sprite.name + ":offset")
		anim.track_insert_key(1, 0, defaultOffset)
		
		var lastFrameLength = 0.0
		var time = lastFrameLength
		
		var frames = spriteanim["frames"]
		var frontKey = ""
		var backKey = ""


		var key = frames.keys()[0].split(".")
		var end = key[key.size()-1]
		key.remove(key.size()-1)
		var front = key.join(".")
		front = front.split(" ")
		front.remove(front.size()-1)
		front = PoolStringArray(front).join(" ")
		frontKey = front + " "
		backKey = "." + end

		for frameIdx in range(startFrame, endFrame+1):
			var frameData = frames[frontKey + str(frameIdx) + backKey]
			
			#anim.track_insert_key(0, time, frameIdx)
			anim.track_insert_key(0, time, Rect2(frameData.frame.x, frameData.frame.y, frameData.frame.w, frameData.frame.h))
			lastFrameLength = frameData["duration"]/1000.0
			time += lastFrameLength
		
		anim.length = time


	for i in range(unloop_anims.size()):
		
		if has_animation(unloop_anims[i]):
			var anim = get_animation(unloop_anims[i])
			
			anim.loop = false
			
			var track_id = anim.add_track(Animation.TYPE_METHOD)
			anim.track_set_path(track_id, "./" + name)
			anim.track_insert_key(track_id, anim.length, {method = "_on_action_finished", args = [unloop_anims[i]] })

		

func _on_action_finished(action_name: String) -> void:
	emit_signal("action_finished", action_name)


func clear_animations() -> void:

	for i in get_animation_list():
		remove_animation(i)
