tool
extends EditorPlugin

const TreeEditor = preload("res://addons/btreeLogic/interface/TreeEditor.tscn")
const BTree = preload("res://addons/btreeLogic/nodes/BehaviourTree.gd")

const LEAVES_DIRECTORY = 'res://btree_logic'

var is_visible = false
var editor_instance
var bottom_panel_button

func _enter_tree():

	
	editor_instance = TreeEditor.instance()
	editor_instance.editor_interface = get_editor_interface()
	editor_instance.script_directory = LEAVES_DIRECTORY
	get_editor_interface().get_editor_viewport().add_child(editor_instance)

	get_editor_interface().get_selection().connect("selection_changed", self, "_on_selection_changed")

	add_custom_type("BTree", "Node", BTree, null)

	make_visible(false)


func _exit_tree():
	
	remove_custom_type("BTree")

	if editor_instance:
		editor_instance.queue_free()


func has_main_screen() -> bool: return true
func get_plugin_name() -> String: return "BTree"

func make_visible(visible):

	if editor_instance:
		editor_instance.visible = visible


func _on_selection_changed() -> void:

	var nodes = get_editor_interface().get_selection().get_selected_nodes()

	
	if nodes.size() == 1 and nodes[0] is BTree:
		get_editor_interface().set_main_screen_editor('BTree')
		editor_instance.load_scene(nodes[0])
	#elif editor_instance and editor_instance.visible:
	#	get_editor_interface().set_main_screen_editor('BTree')


func apply_changes() -> void:

	if editor_instance:
		editor_instance.save()

