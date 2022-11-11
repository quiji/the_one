tool
extends Control

const ALL_NODES = [
	{
		type = 'Composite',
		name = 'Selector',
		scene = preload("res://addons/btreeLogic/interface/BSelector.tscn")
	},
	{
		type = 'Composite',
		name = 'Sequence',
		scene = preload("res://addons/btreeLogic/interface/BSequence.tscn")
	},
	{
		type = 'Decorator',
		name = 'Repeater',
		scene = preload("res://addons/btreeLogic/interface/BRepeater.tscn")
	},
	{
		type = 'Decorator',
		name = 'Repeater until Succeed',
		scene = preload("res://addons/btreeLogic/interface/BRepeatTilSucceed.tscn")
	},
	{
		type = 'Decorator',
		name = 'Repeater until Fail',
		scene = preload("res://addons/btreeLogic/interface/BRepeatTilFail.tscn")
	},
	{
		type = 'Decorator',
		name = 'BInverter',
		scene = preload("res://addons/btreeLogic/interface/BInverter.tscn")
	},
	{
		type = 'Decorator',
		name = 'BSucceeder',
		scene = preload("res://addons/btreeLogic/interface/BSucceeder.tscn")
	},
	{
		type = 'Decorator',
		name = 'BFailer',
		scene = preload("res://addons/btreeLogic/interface/BFailer.tscn")
	},
	{
		type = 'Decorator',
		name = 'BLimiter',
		scene = preload("res://addons/btreeLogic/interface/BLimiter.tscn")
	},
]

const BTree = preload("res://addons/btreeLogic/interface/BTree.tscn")
const BLeaf = preload("res://addons/btreeLogic/interface/BLeaf.tscn")


const START_POS = Vector2(40, 40)
const STEP_OFFSET = Vector2(20, 20)
const TEMPLATE_LEAF_SCRIPT = 'res://addons/btreeLogic/templates/basic_leaf.gd'

onready var graph = $panel/vbox/graph
onready var add_node_btn = $"panel/vbox/Panel/toolbar/add-node"
onready var create_leaf_dialog = $"create-node-dialog"
onready var variable_list = $"panel/vbox/graph/variable-list"

var tree = null
var node_index := 0
var script_directory: String
var editor_interface: EditorInterface
var leaves_menu: PopupMenu
var leaves_nodes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	graph.connect("connection_request", self, "_on_connection_request")
	graph.connect("disconnection_request", self, "_on_disconnect_request")

	var menu = add_node_btn.get_popup()
	
	menu.clear()
	for i in range(ALL_NODES.size()):
		
		var submenu
		if not menu.has_node(ALL_NODES[i].type):
			
			submenu = PopupMenu.new()
			submenu.name = ALL_NODES[i].type
			menu.add_child(submenu)
			menu.add_submenu_item(ALL_NODES[i].type, ALL_NODES[i].type)

			submenu.connect("id_pressed", self, "_on_menu_id_pressed")
		else:
			submenu = menu.get_node(ALL_NODES[i].type)
		
		submenu.add_item(ALL_NODES[i].name, i)

	leaves_menu = PopupMenu.new()
	leaves_menu.name = 'Leaves'
	menu.add_child(leaves_menu)
	menu.add_submenu_item('Leaves', 'Leaves')

	menu.add_separator()
	menu.add_item('New Leaf +', 0)
	menu.connect("id_pressed", self, "_on_menu_options_id_pressed")

	_reload_leaves()

	# Read the leaves directory and build this menu

	leaves_menu.connect("id_pressed", self, "_on_leaves_menu_id_pressed")

	create_leaf_dialog.script_directory = script_directory
	create_leaf_dialog.connect("create_leaf_node", self, "_on_create_leaf_node")

func _reload_leaves() -> void:
	
	leaves_menu.clear()
	leaves_nodes.clear()

	var dir = Directory.new()

	if dir.open(script_directory) != OK:
		return

	dir.list_dir_begin(true, true)

	var next = dir.get_next()

	while next != '':
		if dir.current_is_dir():
			_create_leaves_submenu(script_directory.plus_file(next))
		else:
			leaves_nodes.push_back({
				leaf_name = next.get_basename(),
				namespace = '',
				path = script_directory.plus_file(next)
			})
			#leaves_nodes.push_back(next.get_basename())
			leaves_menu.add_item(next.get_basename(), leaves_nodes.size() - 1)
		next = dir.get_next()

	print(leaves_nodes)

func _create_leaves_submenu(path: String) -> void:

	var namespace_name = path.get_file()
	var submenu = PopupMenu.new()
	submenu.name = namespace_name
	leaves_menu.add_child(submenu)
	leaves_menu.add_submenu_item(namespace_name, namespace_name)
	submenu.connect("id_pressed", self, "_on_leaves_menu_id_pressed")

	var subdir = Directory.new()

	if subdir.open(path) != OK:
		return

	subdir.list_dir_begin(true, true)

	var next = subdir.get_next()

	while next != '':

		if not subdir.current_is_dir():
			leaves_nodes.push_back({
				leaf_name = next.get_basename(),
				namespace = namespace_name,
				path = script_directory.plus_file(namespace_name).plus_file(next)
			})
			submenu.add_item(next.get_basename(), leaves_nodes.size() - 1)
		next = subdir.get_next()
	

func load_scene(new_tree) -> void:

	if tree == new_tree:
		return

	if tree != null:
		save()
		editor_interface.save_scene()
		cleanup()
		

	node_index = 0
	tree = new_tree
	
	tree.connect("tree_exiting", self, "_on_tree_scene_closed")

	_reload_leaves()
	
	if not tree.has_meta('nodes'):
		new_tree()
	else:
		load_tree()
	
func new_tree() -> void:
	var node = BTree.instance()

	graph.add_child(node)
	node.offset = START_POS
	node_index += 1

	node.editor = editor_interface

func load_tree() -> void:
	var data = tree.get_meta('nodes')

	print("loading tree")
	variable_list.set_data(tree.get_meta('params'))
	if tree.has_meta('tunnels'):
		print("get tunnel data: ", tree.get_meta('tunnels'))
		variable_list.set_tunnel_data(tree.get_meta('tunnels'))

	for node in data:
		var node_data = data[node]

		var new_node = load(node_data.node_type).instance()
		new_node.name = node
		print("created node ", new_node)
		new_node.editor = editor_interface
		graph.add_child(new_node)
		new_node.set_data(node_data)

		if new_node.script_path != '':
			new_node.connect("open_script", self, "_on_script_edit_command")

	if not tree.has_meta('connections'): return

	var conns = tree.get_meta('connections')
	for conn in conns:
		if graph.has_node(conn.from) and graph.has_node(conn.to):
			graph.connect_node(conn.from, conn.from_port, conn.to, conn.to_port)
	

func discharge() -> void:


	if not tree:
		return	

	tree = null



func save() -> void:

	if not tree:
		return

	print("saving tree")

	

	var nodes = {}
	for i in range(graph.get_child_count()):
		var child = graph.get_child(i)

		if not (child is GraphNode):
			continue
		
		nodes[child.name] = child.generate_data()
		
	
	tree.set_meta('nodes', nodes)
	tree.set_meta('connections', graph.get_connection_list())
	tree.set_meta('params', variable_list.get_data())
	tree.set_meta('tunnels', variable_list.get_tunnel_data())

	print("save tunnel data: ", tree.get_meta('tunnels'))

func cleanup() -> void:

	if tree and tree.is_connected("tree_exiting", self, "_on_tree_scene_closed"):
		tree.disconnect("tree_exiting", self, "_on_tree_scene_closed")
	

	graph.clear_connections()

	var children = graph.get_children()
	for i in range(children.size()):
		if children[i] is GraphNode:
			children[i].queue_free()

	variable_list.clear()

func _on_menu_id_pressed(id: int):
	
	insert_node(ALL_NODES[id].scene.instance())

func _on_leaves_menu_id_pressed(id: int) -> void:
	
	insert_leaf_node(leaves_nodes[id].namespace, leaves_nodes[id].leaf_name, leaves_nodes[id].path)
	#print(leaves_nodes[id])
	
		

func _on_menu_options_id_pressed(id: int) -> void:

	if id == 0:
		create_leaf_dialog.popup_centered_minsize(Vector2(800, 300))

func _on_create_leaf_node(namespace, leaf_name, filename, namespace_directory) -> void:

	var dir = Directory.new()

	if not dir.dir_exists(namespace_directory):
		dir.make_dir(namespace_directory)

	if not dir.file_exists(filename):
		
		var script = File.new()
		var template := ''
		script.open(TEMPLATE_LEAF_SCRIPT, File.READ)
		template = script.get_as_text()
		script.close()

		var file = File.new()
		file.open(filename, File.WRITE)
		file.store_string(template)
		file.close()

	insert_leaf_node(namespace, leaf_name, filename)

	_reload_leaves()

func insert_leaf_node(namespace, leaf_name, filename) -> void:

	var new_node = BLeaf.instance()
	new_node.script_path = filename
	if namespace != '':
		new_node.title = namespace + '-' + leaf_name
	else:
		new_node.title = leaf_name

	insert_node(new_node)
	new_node._data_updated()

func insert_node(node) -> void:
	graph.add_child(node)
	node_index += 1
	node.offset = graph.scroll_offset + START_POS + STEP_OFFSET * node_index

	node.editor = editor_interface


func _on_connection_request(from, from_slot, to, to_slot) -> void:
	
	var list = graph.get_connection_list()
	var connector_used = false

	for conn in list:

		if conn.from == from and conn.from_port == from_slot:
			connector_used = true
		elif conn.to == to and conn.to_port == to_slot:
			connector_used = true

	if connector_used:
		return 

	graph.connect_node(from, from_slot, to, to_slot)

	print("connected something ", from, " slot ", from_slot, " to ", to, " to_slot ", to_slot)
	graph.get_node(from).slot_updated()
	
	


func _on_disconnect_request(from, from_slot, to, to_slot) -> void:
	
	graph.disconnect_node(from, from_slot, to, to_slot)
	
func _on_tree_scene_closed() -> void:

	#editor_interface.save_scene()

	cleanup()
	tree = null

