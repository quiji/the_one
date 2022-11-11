tool
extends PanelContainer


onready var export_typings_lbl = $"hbox/export-typing-lbl"
onready var export_name_lbl = $"hbox/export-name-lbl"
onready var connect_btn = $"hbox/connect-btn"
onready var disconnect_btn = $"hbox/disconnect-btn"
onready var tunnel_name_lbl = $"hbox/tunnel-name-lbl"
onready var panel_sbf:StyleBoxFlat = get('custom_styles/panel')

var varible_list = null
var tunnel_param = ''
var var_data = {}

func _ready():
	var list = get_tree().get_nodes_in_group("BTreeLogic_VariableList")

	varible_list = list[0]


func set_data(data: Dictionary) -> void:
	
	if data.type == 0:
		export_typings_lbl.text = '[Arr]'
	elif data.type == 1:
		export_typings_lbl.text = '[Dict]'
	elif data.type == 2:
		export_typings_lbl.text = '[Str]'
	elif data.type == 3:
		export_typings_lbl.text = '[Num]'

	name = data.name
	
	export_name_lbl.text += data.name
	var_data = data

	_check_connection()

func get_type() -> String:
	return var_data.type

func get_var_name() -> String:
	return var_data.name

func get_node_owner() -> String:
	return var_data.owner

func get_tunnel_name() -> String:
	return tunnel_name_lbl.text

func  _check_connection() -> void:
	var connection :Dictionary = varible_list.check_connections(var_data)

	if not connection.empty():
		tunnel_param = connection.param_name
		tunnel_name_lbl.text = tunnel_param
		connect_btn.hide()
		disconnect_btn.show()
		tunnel_name_lbl.show()
		panel_sbf.bg_color = connection.color
	else:
		tunnel_name_lbl.hide()
		tunnel_name_lbl.text = ''
		connect_btn.show()
		disconnect_btn.hide()
		panel_sbf.bg_color = Color(0.0, 0.0, 0.0 ,0.0)
	

func _on_connectbtn_pressed():


	varible_list.request_connection(self)
	
	#_check_connection()

func disconnect_manually() -> void:

	if tunnel_name_lbl.visible:
		varible_list.remove_connection(tunnel_name_lbl.text, self)
		panel_sbf.bg_color = Color(0.0, 0.0, 0.0 ,0.0)

func _on_disconnectbtn_pressed():
	
	varible_list.remove_connection(tunnel_name_lbl.text, self)
	
	disconnect_param()

func disconnect_param():
	tunnel_name_lbl.hide()
	tunnel_name_lbl.text = ''
	connect_btn.show()
	disconnect_btn.hide()
	panel_sbf.bg_color = Color(0.0, 0.0, 0.0 ,0.0)


func connected_to(global_param: String, col: Color) -> void:
	tunnel_name_lbl.text = global_param
	connect_btn.hide()
	disconnect_btn.show()
	tunnel_name_lbl.show()
	panel_sbf.bg_color = col


func update_params_tunnel_name(new_name) -> void:
	tunnel_name_lbl.text = new_name

