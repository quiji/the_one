tool
extends WindowDialog

signal create_leaf_node(namespace, leaf_name, filename, namespace_dir)

onready var cancel_btn = $'margins/vbox/buttons/cancel-btn'
onready var leaf_name_edt = $"margins/vbox/HBoxContainer/leaf-name-edt"

var script_directory: String = ''

func _ready():

	connect("about_to_show", self, "_on_about_to_show")

func _on_cancelbtn_pressed():
	visible = false

func _on_createbtn_pressed():
	visible = false

	var namespace:= ''
	var leaf_name := ''
	var directory := ''
	var filename := script_directory

	var pieces = leaf_name_edt.text.split('/')

	leaf_name = pieces[pieces.size() - 1].strip_edges().replace(' ', '_')
	if pieces.size() > 1:
		namespace = pieces[0].strip_edges()
	
	if namespace != '':
		namespace = namespace.strip_edges().replace(' ', '_')
		filename = filename.plus_file(namespace)
		directory = filename

	filename = filename.plus_file(leaf_name + '.gd')
		
	emit_signal("create_leaf_node", namespace, leaf_name, filename, directory)


func _on_about_to_show() -> void:

	leaf_name_edt.text = ''


func _on_leafnameedt_text_entered(new_text:String):
	_on_createbtn_pressed()
