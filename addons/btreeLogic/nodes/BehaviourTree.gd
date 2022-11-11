tool
extends Node

class_name BehaviourTree

signal behaviour_tree_completed


const NODES = {
	Failer = BehaviourFailer,
	Inverter = BehaviourInverter,
	Limiter = BehaviourLimiter,
	Repeater = BehaviourRepeater,
	RepeatTilFail = BehaviourRepeatFail,
	RepeatTilSucceed = BehaviourRepeatSucceed,
	Selector = BehaviourSelector,
	Sequence = BehaviourSequence,
	Succeeder = BehaviourSucceed,
	CustomLeafNode = Node
}

export (bool) var autorun = true
export (bool) var debugging = false
export (float) var fps = 60.0

const RunningBehaviour = 0 
const SucceededBehaviour = 2 
const FailedBehaviour = 3


var actor = null

var tunnel_data = {}
var tunnels = {}
var current_node = null

func _ready():


	if Engine.editor_hint: 
		set_process(false)
		return

	if get_child_count() == 0:
		_build_tree()

	actor = get_parent()


	set_process(autorun)

func _build_tree() -> void:
	var nodes = get_meta("nodes")
	var connections = get_meta("connections")
	var parameters = get_meta("params")
	tunnels = get_meta("tunnels")

	for param in parameters:
		if param.type == 0:
			tunnel_data[param.param] = []
		elif param.type == 1:
			tunnel_data[param.param] = {}
		elif param.type == 2 :
			tunnel_data[param.param] = ""
		elif param.type == 3:
			tunnel_data[param.param] = 0

	
	var  node_holder = {}
	for node in nodes:
		
		if nodes[node].node_class != '':
			node_holder[node] = NODES[nodes[node].node_class].new()
			node_holder[node].name = node
			#node_holder[node].set('root', self)

			for param in nodes[node].node_parameters:
				node_holder[node].set(param, nodes[node].node_parameters[param])

			if nodes[node].node_script_path != '':
				node_holder[node].set_script(load(nodes[node].node_script_path))
			
	
	for conn in connections:

		if nodes[conn.from].node_class == '':
			add_child(node_holder[conn.to])
		else:
			node_holder[conn.from].add_child(node_holder[conn.to])

func set_tunnel_param(param_name: String, value) -> void:
	tunnel_data[param_name] = value

func run():

	get_child(0).propagate_start(self)

	set_process(true)

func child_returned(result):

	set_process(false)
	current_node = null
	emit_signal("behaviour_tree_completed")

	if debugging:
		_log('Tree completed: ' + str(result))
	


var deltas = 0
var current_state
var last_was_leaf := false
var run_id = 0

func _process(delta):

	
	deltas -= delta
	
	if deltas <= 0:
		run_id += 1
		if current_node == null:
			set_new_current_node(get_child(0))

		current_state = current_node.get_state() 

		if current_state != RunningBehaviour:

			if debugging:
				_log(current_node)

			return_to_parent(current_node, current_state)
		
		if current_node != null:
			current_node.do_run(delta)
		#"""
		
		deltas = 1.0 / fps

	if run_id > 100000:
		run_id = 0


func set_new_current_node(node):
	current_node = node

	for tuna in tunnels:

		for data in tunnels[tuna]:
			if data.node == current_node.name:
				current_node.set(data.param, tunnel_data[tuna])


	current_node.initialice()
	if debugging:
		_log(current_node)

func return_to_parent(node, result):

	for tuna in tunnels:
		for data in tunnels[tuna]:
			if data.node == node.name:
				tunnel_data[tuna] = node.get(data.param)



	var list = node.get_tunnels()	
	for tunnel in list:
		tunnel_data[tunnel] = node.get(tunnel)

	current_node = node.get_parent()
	current_node.child_returned(result)

func _log(node) -> void:

	print(node)
