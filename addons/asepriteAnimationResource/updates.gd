
const FILE_LOCATION = 'res://addons/asepriteAnimationResource/updates.cfg'

var updates

func _init():

    var new_file: File = File.new()
    updates = ConfigFile.new()

    if not new_file.file_exists(FILE_LOCATION):
        updates.save(FILE_LOCATION)
    else:
        updates.load(FILE_LOCATION)


func set_updated(res_path, is_it=true):
    print('Aseprite resource ', res_path, ' has been updated')
    updates.set_value('updates', res_path, is_it)

func is_updated(res_path):
    return updates.get_value('updates', res_path, true)

func get_all_aseprite_resources_path():

    return updates.get_section_keys('updates')

func remove_aseprite_path(path):
    updates.erase_section_key('updates', path)

func save():

    print("Saved aseprite data states")
    updates.save(FILE_LOCATION)