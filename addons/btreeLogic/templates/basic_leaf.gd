extends Leaf

############################################################################################################
# Define variables to receive data with variable exports,
# the tree will feed the data using the name as reference on the top level
############################################################################################################

#export var data = {}


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
# While the node is running, this method will be executed _process(delta) style
# call succeeded() when node completed succesfully or failed() otherwise
# Access methods from the parent node of the Tree by using the actor property inherited by BehaviourClass
############################################################################################################
func run(delta) -> void:
	pass

