extends Leaf

############################################################################################################
#  Just don't change this please, hahaha
############################################################################################################
func is_composite() -> bool:
	return true

############################################################################################################
#  Called every time the tree starts running
############################################################################################################

func tree_start() -> void:
	pass


############################################################################################################
#  Called every time the leaf is about to start running
############################################################################################################
func init() -> void:
	pass

############################################################################################################
# This method will be called when child node finished its execution succesfully
############################################################################################################
func child_succeeded() -> void:
	pass
	
############################################################################################################
# his method will be called when child node fails its execution
############################################################################################################
func child_failed() -> void:
	pass

############################################################################################################
# While the node is running, this method will be executed _process(delta) style
# call succeeded() when node completed succesfully or failed() otherwise
# call run_child(idx) to pass execution to child node. This node has to handle its own child count
# and use child_succeeded and child_failed to handle its own code flow.
############################################################################################################
func run(delta) -> void:
	pass

