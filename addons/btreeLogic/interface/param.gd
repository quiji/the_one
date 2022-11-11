tool
extends PanelContainer

signal param_deleted
signal param_name_edited(old_name, new_name)

onready var param_name_edt = $"hbox/param-name-edt"
onready var param_type_opt = $"hbox/param-type"
onready var save_btn = $"hbox/save-btn"
onready var panel_sbf :StyleBoxFlat  = get('custom_styles/panel')
var current_name := ''


func _ready():
	current_name = name
	param_name_edt.text = name
	save_btn.hide()

	panel_sbf.bg_color = Color( rand_range(0.0, 0.8), rand_range(0.0, 0.8), rand_range(0.0, 0.8), 0.5)



func _on_closebtn_pressed():
	emit_signal("param_deleted")
	queue_free()


func _on_paramnameedt_text_entered(new_text:String):

	param_name_edt.text = new_text.strip_edges().replace(' ', '_').validate_node_name()

	save_btn.visible = current_name != param_name_edt.text


func _on_paramnameedt_focus_exited():

	param_name_edt.text = param_name_edt.text.strip_edges().replace(' ', '_').validate_node_name()

	save_btn.visible = current_name != param_name_edt.text


func get_data() -> Dictionary:

	return {
		param = current_name,
		type = param_type_opt.selected
	}

func set_data(data: Dictionary) -> void:

	name = data.param
	current_name = data.param
	param_name_edt.text = data.param
	param_type_opt.selected = data.type

func _on_savebtn_pressed():
	
	
	emit_signal("param_name_edited", current_name, param_name_edt.text)
	current_name = param_name_edt.text
	save_btn.hide()


func _on_paramtype_item_selected(index:int):
	
	#erase connectios as type doesn't match anymore
	emit_signal("param_deleted")
