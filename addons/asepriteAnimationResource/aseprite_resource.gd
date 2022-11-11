extends Resource

export (Dictionary) var data = {} setget set_data
export var animation_list = []
export var animation_filenames = []
export var last_updated := 0
export var updated := false
export var anims_path := ''
export (Dictionary) var cels_metadata = {}


#class_name AsepriteResource, "aseprite_resource_icon.png"


func set_data(new_data: Dictionary) -> void:
    
    data = new_data

    last_updated = OS.get_unix_time()
    updated = true

    animation_list = []
    animation_filenames = []
    cels_metadata.clear()
    emit_changed()


func append_animation(anim_name: String) -> void:

    animation_list.push_back(anim_name)

    animation_filenames.push_back(anim_name + '.anim')


