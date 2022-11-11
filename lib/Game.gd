extends Node



################################
const DEV_MODE = true
################################


func _ready():
	if DEV_MODE:
		Console.active = true
	else:
		Console.active = false

	
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	#Console.add_command("open_doors", self, "_open_doors", "Open all block doors")
	#Console.add_command("close_doors", self, "_close_doors", "Close all block doors")



"""
func _open_doors(args) -> void:
	
	if args.size() > 0:
		get_tree().call_group("block_doors", "open_if_owner", args[0])
	else:
		get_tree().call_group("block_doors", "open")

func _close_doors(args) -> void:
	
	if args.size() > 0:
		get_tree().call_group("block_doors", "close_if_owner", args[0])
	else:
		get_tree().call_group("block_doors", "close")
"""

