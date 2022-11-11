extends "res://addons/btreeLogic/nodes/BehaviourClass.gd"
class_name BehaviourLimiter

export (int) var execution_limit = 1

var total_executions = 0


func tree_start() -> void:
	total_executions = 0


func init():
	pass
	
func run(delta):

	if total_executions >= execution_limit:
		failed()
	else:
		total_executions += 1
		run_child(0)
		

func child_succeeded():
	succeeded()
	
func child_failed():
	failed()




