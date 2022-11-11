tool
extends EditorPlugin

const AsepriteAnimationPlayer = preload("AsepriteAnimationPlayer.gd")

var import_plugin = null
var current_animation = null

func _enter_tree():
	import_plugin = preload("import_plugin.gd").new()
	add_import_plugin(import_plugin)	

	add_custom_type("AsepriteResource", "Resource", preload("aseprite_resource.gd"), preload("aseprite_resource_icon.png"))
	add_custom_type("AsepriteAnimationPlayer", "AnimationPlayer", AsepriteAnimationPlayer, preload("aseprite_resource_icon.png"))

func save_external_data():

	var AseResourceUpdates = preload('res://addons/asepriteAnimationResource/updates.gd').new()

	var paths = AseResourceUpdates.get_all_aseprite_resources_path()
	var remove_count = 0
	print("checking orphan aseprite resources...")
	for res_path in paths:

		if is_orphan_resource(res_path):
			print(res_path, " is an orphan resource directory, removing...")

			_cleanup(res_path)

			var dir = Directory.new()
			dir.remove(res_path)

			AseResourceUpdates.remove_aseprite_path(res_path)
			remove_count += 1

	if remove_count > 0:
		AseResourceUpdates.save()

	print("finished checking orphan aseprite resources, removed ", remove_count, " orphan resource directories")


func _exit_tree():
	remove_import_plugin(import_plugin)
	import_plugin = null

	remove_custom_type("AsepriteResource")
	remove_custom_type("AsepriteAnimationPlayer")


func handles(obj: Object) -> bool:
	return obj.has_method("set_aseprite_data")


func edit(obj: Object) -> void:
	
	current_animation = obj
	

func make_visible(visible: bool) -> void:

	var update_data = null
	if visible and current_animation:
		print("Checking aseprite resource updates...")
		update_data = current_animation.check_updates()


	if update_data != null:
		print("Doing cleanup...")

		_cleanup(update_data.dir, update_data.anims)

		print("Cleanup completed")

func is_orphan_resource(path) -> bool:

	var splits = path.split('/')
	var target_name = splits[splits.size() - 1]
	splits.remove(splits.size() - 1)
	
	var base_path = splits.join('/')
	
	splits = target_name.split('.')
	splits.remove(splits.size() - 1)
	target_name = splits.join('.')

	var dir = Directory.new()
	
	return not dir.file_exists(base_path + '/' + target_name + '.ason')

#beware!! if no list is provided, it will ERASE ALL FILES in directory
func _cleanup(update_dir, list=[]):
	var dir = Directory.new()

	if dir.dir_exists(update_dir) and dir.open(update_dir) == OK:
	
		var total_files = []
		dir.list_dir_begin(true, true)
		
		var current_file = dir.get_next()
		while current_file != "":
			
			if not dir.current_is_dir() and list.find(current_file) == -1:
				total_files.push_back(current_file)
			
			current_file = dir.get_next()

		for file in total_files:
			print("removing unused animation ", file)
			dir.remove(file)

