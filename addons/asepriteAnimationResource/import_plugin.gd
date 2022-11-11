tool
extends EditorImportPlugin

enum AsepriteAnimationPresets {Default}

var regex : RegEx

func _init():
	regex = RegEx.new()
	regex.compile("^([.\\/\\w]+)\\(\\)$|^(\\w+)=(true|false|\\d+|\\d+.\\d+)$")
	# 3 gropus, first is function name, second is parameter name, and third is value assigned
	

# unique Godot name to id a exported resource
func get_importer_name(): return "aseprite.ason"

func get_visible_name(): return "Aseprite Animation"

func get_recognized_extensions(): return ['ason']

func get_save_extension(): return 'tres'

func get_resource_type(): return 'Resource'


func get_preset_count(): return AsepriteAnimationPresets.size()

func get_preset_name(preset: int):
    match preset:
        AsepriteAnimationPresets.Default:
            return "Default"
    
    return "unknown"


func get_import_options(preset: int):
    match preset:
        AsepriteAnimationPresets.Default:
            return [{
                name = "target_sprite_name",
                default_value = "sprite",
                property_hint = "Sprite that holds the aseprite exported image. If not on the same node level it might have a node tree path"
            },
			{
                name = "target_animation_player_name",
                default_value = "anims",
                property_hint = "AsepriteAmationPlayer node which has the animations"
            }]
    
    return []

func get_option_visibility(option, options): return true


func get_target_directory(source_file):

	var final_name = ''
	# remove extension
	var pieces = source_file.split('.')
	pieces.remove(pieces.size() - 1)
	var path = pieces.join('.')

	# get file name
	pieces = path.split('/')
	final_name += pieces[pieces.size() - 1]+'.anims'
	pieces.remove(pieces.size() - 1)
	path = pieces.join('/') + '/' + final_name

	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)

	return path

func _parse_reaction(react: String):


	var result = regex.search(react)
	if not result: 
		return null
	
	if result.strings[1]:
		return {call = result.strings[1]}
	elif result.strings[2]:

		var value
		
		if result.strings[3] == "true":
			value = true
		elif result.strings[3] == "false":
			value = false
		elif result.strings[3].find(".") > -1:
			value = float(result.strings[3])
		else:
			value = int(result.strings[3])

		return {set = result.strings[2], to = value}

	

func import(source_file, save_path, options, platform_variants, gen_files):

	var ase_resource = preload('aseprite_resource.gd').new()

	var target_path = get_target_directory(source_file)
	
	ase_resource.anims_path = target_path

	var file = File.new()
	var err = file.open(source_file, File.READ)
	if err != OK:
		return err

	var data_text = file.get_as_text()
	file.close()

	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		return data_parse.error

	var spriteanim = data_parse.result
	
	var is_array = spriteanim.frames is Array
	var result_anim

	ase_resource.data = spriteanim
	

	var cels_metadata = {}
	for layer in spriteanim.meta.layers:
		if not layer.has('cels'):
			continue
		
		for cel in layer.cels:
			if not cels_metadata.has(int(cel.frame)):
				cels_metadata[int(cel.frame)] = []
		
			var actions = cel.data.split(";")
			for action in actions:
				var pieces = action.split(":")
				var final_action = {}
				var action_to_take = _parse_reaction(pieces[1].strip_edges())

				if not action_to_take:
					continue

				final_action[pieces[0].strip_edges()] = action_to_take
				
				cels_metadata[int(cel.frame)].push_back(final_action)

	ase_resource.cels_metadata = cels_metadata
	print("metadata extracted: ", cels_metadata)

	for tag in spriteanim.meta.frameTags:
		var anim := Animation.new()

		var anim_name : String = tag.name
		var is_loopable := true

		# ignore character
		if anim_name.begins_with('-'):
			continue
		elif anim_name.begins_with('*'):
			anim_name = anim_name.substr(1)
			is_loopable = false
		

		ase_resource.append_animation(anim_name)
		print("doing ", anim_name)

		anim.loop = is_loopable
		anim.add_track(Animation.TYPE_VALUE)
		anim.add_track(Animation.TYPE_VALUE)
		anim.add_track(Animation.TYPE_VALUE)
		anim.add_track(Animation.TYPE_METHOD)
		anim.track_set_interpolation_type(0, Animation.INTERPOLATION_NEAREST)
		anim.track_set_interpolation_type(1, Animation.INTERPOLATION_NEAREST)
		anim.track_set_interpolation_type(2, Animation.INTERPOLATION_NEAREST)
		anim.track_set_path(0, options.target_sprite_name + ":region_enabled")
		anim.track_set_path(1, options.target_sprite_name + ":region_rect")
		anim.track_set_path(2, options.target_sprite_name + ":offset")
		anim.track_set_path(3, "./" + options.target_animation_player_name)
		anim.track_insert_key(0, 0, true)
		anim.track_insert_key(2, 0, Vector2.ZERO)
		


		var lastFrameLength = 0.0
		var time = lastFrameLength
		
		var frames = spriteanim.frames
		var frontKey = ""
		var backKey = ""
		if not is_array:
			var key = frames.keys()[0].split(".")
			var end = key[key.size()-1]
			key.remove(key.size()-1)
			var front = key.join(".")
			front = front.split(" ")
			front.remove(front.size()-1)
			front = PoolStringArray(front).join(" ")
			frontKey = front + " "
			backKey = "." + end
		
		for frameIdx in range(tag.from, tag.to+1):
			var frameData
			
			if not is_array:
				frameData = frames[frontKey + str(frameIdx) + backKey]
			else:
				frameData = frames[frameIdx]
			
			if cels_metadata.has(frameIdx) and cels_metadata[frameIdx].size() > 0:
				anim.track_insert_key(3, time, {method = "_execute", args = [cels_metadata[frameIdx]] })

			anim.track_insert_key(1, time, Rect2(frameData.frame.x, frameData.frame.y, frameData.frame.w, frameData.frame.h))
			lastFrameLength = frameData.duration/1000.0
			time += lastFrameLength
		
		anim.length = time

		
		var res_err = ResourceSaver.save("%s/%s.%s" % [target_path, anim_name, 'anim'], anim)

		if err != OK:
			print("error doing ", anim_name)
			return res_err



	var AseResourceUpdates = preload('updates.gd').new()

	AseResourceUpdates.set_updated(target_path)
	AseResourceUpdates.save()

	return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], ase_resource)

