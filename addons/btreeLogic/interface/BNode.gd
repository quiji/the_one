tool
extends GraphNode

signal open_script

export var growing_slots = false
export (String) var base_node := ""
export var script_path := ''

onready var parameter_hbox = $parameters

var editor: EditorInterface


func _ready():

	connect("close_request", self, "_on_close_request")
	connect("resize_request", self, "_on_resize_request")


func _on_close_request() -> void:

	var list = get_parent().get_connection_list()

	for i in range(list.size()):
		if list[i].from == name or list[i].to == name:
			get_parent().disconnect_node(list[i].from, list[i].from_port, list[i].to, list[i].to_port)

	_node_deletion_requested()

	queue_free()

func _on_resize_request(size: Vector2) -> void:
	rect_size = size


func slot_updated() -> void:

	if not growing_slots:
		return

	if get_child_count() == get_connection_output_count():
		_add_slot()

func _add_slot() -> void:
	var control = Control.new()
	control.rect_min_size.y = 26
	add_child(control)
	set_slot(get_child_count() - 1, false, 0, Color(1, 1, 1), true, 0, Color('#80e699'))

func generate_data() -> Dictionary:

	var params = {}

	for child in parameter_hbox.get_children():

		if child is SpinBox:
			child.apply()
			params[child.name] = child.value
		elif child is LineEdit:
			params[child.name] = child.text
		
	return {
		node_name = title,
		node_type = filename,
		node_rect_size = rect_size,
		node_offset = offset,
		node_ports = get_child_count(),
		node_class = base_node,
		node_script_path = script_path,
		node_parameters = params
	}

func set_data(data: Dictionary):
	
	title = data.node_name
	rect_size = data.node_rect_size
	offset = data.node_offset
	script_path = data.node_script_path

	for param in data.node_parameters:
		
		var target_node = parameter_hbox.get_node(param)
		if target_node is SpinBox:
			target_node.value = data.node_parameters[param]
		elif target_node is LineEdit:
			target_node.text = data.node_parameters[param]
			
	while growing_slots and get_child_count() < data.node_ports:
		_add_slot()


	_data_updated()


################################################################################################
# Methods to override
################################################################################################

func _data_updated() -> void:
	pass


func _node_deletion_requested() -> void:
	pass