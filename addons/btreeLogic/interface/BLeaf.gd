tool
extends "res://addons/btreeLogic/interface/BNode.gd"

const leafParam = preload("res://addons/btreeLogic/interface/leaf-param.tscn")

onready var tunnel_vbox = $parameters/vbox
onready var open_script_btn = $"open-script-btn"

func _on_openscriptbtn_pressed():

	
	if script_path != '':
		editor.edit_script(load(script_path))

		
func _data_updated() -> void:

	if script_path == '': return

	var dummy = Node.new()
	dummy.set_script(load(script_path))
	
	generate_prop_list(dummy)

	dummy.queue_free()

func _node_deletion_requested() -> void:

	for i in range(tunnel_vbox.get_child_count()):
		var child = tunnel_vbox.get_child(i)

		child.disconnect_manually()

func generate_prop_list(dummy: Node) -> void:
	var list = dummy.get_property_list()

	for prop in list:
		
		if prop.usage == 8199:
			#print(prop)
			var type := 0
			if prop.type == 19:  # []
				type = 0
			elif prop.type == 18: # {}
				type = 1
			elif prop.type == 4: # ""
				type = 2
			elif prop.type == 2: # 0
				type = 3
			
			var param_node = leafParam.instance()

			tunnel_vbox.add_child(param_node)

			param_node.set_data({
				name = prop.name,
				type = type,
				owner = name
			})

func get_param(param_name):

	if tunnel_vbox.has_node(param_name):
		return tunnel_vbox.get_node(param_name)