tool
extends MarginContainer

const paramNode = preload("res://addons/btreeLogic/interface/param.tscn")

export var assign_param_dialog:NodePath

onready var list = $vbox/list
onready var add_btn = $"vbox/list/add-param"
onready var show_btn = $"vbox/show-btn"

var tunnels = {}
var assign_param_dialog_node

func _ready():
	add_to_group("BTreeLogic_VariableList")

	if assign_param_dialog and has_node(assign_param_dialog):
		assign_param_dialog_node = get_node(assign_param_dialog)

func _on_showbtn_toggled(button_pressed:bool):
	list.visible = button_pressed

	show_btn.text = 'params (' + str(list.get_child_count() - 1) + ')'


func _on_addparam_pressed():

	add_param()
	show_btn.text = 'params (' + str(list.get_child_count() - 1) + ')'

func add_param(data=null) -> void:
	var new_param = paramNode.instance()


	new_param.connect("param_deleted", self, "_on_param_deleted", [new_param])
	new_param.connect("param_name_edited", self, "_on_param_namne_edited", [new_param])
	list.add_child(new_param)
	list.move_child(add_btn, list.get_child_count() - 1)

	if data != null:
		new_param.set_data(data)

func get_data() -> Array:

	var result = []
	for i in range(list.get_child_count() - 1):

		var child = list.get_child(i)

		result.push_back(child.get_data())

	return result

func set_data(data: Array) -> void:

	for i in range(data.size()):

		add_param(data[i])

func get_tunnel_data() -> Dictionary:
	return tunnels

func set_tunnel_data(data: Dictionary) -> void:
	tunnels = data
	

func clear() -> void:

	var children = list.get_children()

	for i in range(children.size() - 1):
		children[i].queue_free()

	tunnels = {}

func _on_param_deleted(who) -> void:
	var data = who.get_data()
	
	if not tunnels.has(data.param):
		return

	for i in range(tunnels[data.param].size()):
		var target = get_node_param(tunnels[data.param][i].node, tunnels[data.param][i].param)
		target.disconnect_param()

	tunnels.erase(data.param)

	show_btn.text = 'params (...)'

func get_node_param(node_name: String, param_name: String):
	if get_parent().has_node(node_name):
		return get_parent().get_node(node_name).get_param(param_name)
	
	return null

func _on_param_namne_edited(old_name: String, new_name: String, who) -> void:

	if tunnels.has(old_name):
		tunnels[new_name] = tunnels[old_name]
		tunnels.erase(old_name)
		for i in range(tunnels[new_name].size()):
			var target = get_node_param(tunnels[new_name][i].node, tunnels[new_name][i].param)
			target.update_params_tunnel_name(new_name)
	

func check_connections(data: Dictionary) -> Dictionary:

	for param in tunnels:
		
		for conn in tunnels[param]:

			if conn.node == data.owner and conn.param == data.name:
				
				return {param_name = param, color = list.get_node(param).panel_sbf.bg_color}
	
	return {}

func request_connection(who) -> void:
	
	assign_param_dialog_node.ask_for(self, who)
	
	
func consolidate_connection(who, what: int) -> void:
	var data = list.get_child(what).get_data()

	if not tunnels.has(data.param):
		tunnels[data.param] = []

	tunnels[data.param].push_back({
		node = who.get_node_owner(),
		param = who.get_var_name()
	})

	
	who.connected_to(data.param, list.get_child(what).panel_sbf.bg_color)

func remove_connection(param_key, who):

	var index := -1
	var i := 0

	while i < tunnels[param_key].size() and index == -1:
		if tunnels[param_key][i].node == who.get_node_owner() and tunnels[param_key][i].param == who.get_var_name():
			index = i
		i += 1

	if index != -1:
		tunnels[param_key].remove(index)
	
	