extends Node
class_name Leaf

const RunningBehaviour = 0 
const SucceededBehaviour = 1 
const FailedBehaviour = 2


var root = null
var actor = null
var _tunnel_data = []

var current_node_state 

func _init():

	var list = get_property_list()

	for prop in list:
		
		if prop.usage == 8199:
			_tunnel_data.push_back(prop.name)


func _to_string() -> String:

	var state := ''

	if current_node_state == RunningBehaviour:
		state = 'RunningBehaviour'
	elif current_node_state == FailedBehaviour:
		state = 'FailedBehaviour'
	else:
		state = 'SucceededBehaviour'

	var trace: PoolStringArray = [];
	var current = get_parent();

	while current.has_method('is_leaf'):
		trace.insert(0, current.name)
		current = current.get_parent()

	trace.insert(0, current.name)
	
	return trace.join(' > ') + ' > [' + name + '] === ' + state

func do_run(delta):

	if current_node_state == RunningBehaviour:
		run(delta)
		
func failed():
	current_node_state = FailedBehaviour
	

func succeeded():
	current_node_state = SucceededBehaviour



func initialice():

	current_node_state = RunningBehaviour


	init()
	

func get_state():
	return current_node_state

func run_child(idx):
	root.set_new_current_node(get_child(idx))


func child_returned(result):
	if result == SucceededBehaviour:
		child_succeeded()
	else:
		child_failed()

func is_leaf() -> bool:
	return get_child_count() == 0

func is_composite() -> bool:
	return false

func is_decorator() -> bool:
	return not is_composite() and get_child_count() == 1


func propagate_start(base_root) -> void:
	root = base_root
	actor = root.actor
	tree_start()

	for i in range(get_child_count()):
		get_child(i).propagate_start(base_root)

func get_tunnels() -> Array:
	return _tunnel_data

################################################################################################
# Override methods
################################################################################################

func tree_start() -> void:
	pass

func init() -> void:
	pass

func child_succeeded() -> void:
	pass
	
func child_failed() -> void:
	pass

func run(delta) -> void:
	pass

