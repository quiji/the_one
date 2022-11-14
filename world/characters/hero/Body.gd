tool
extends Node2D

enum Directions {Up, UpRight, Right, DownRight, Down, DownLeft, Left, UpLeft}

onready var direction_list:PoolVector2Array = [Vector2.UP, (Vector2.UP + Vector2.RIGHT).normalized(), Vector2.RIGHT, (Vector2.DOWN + Vector2.RIGHT).normalized(), Vector2.DOWN, (Vector2.DOWN + Vector2.LEFT).normalized(), Vector2.LEFT, (Vector2.UP + Vector2.LEFT).normalized()]
onready var anims = $anims
onready var view_direction: Vector2


const BEAK_STATES = [
	{ #Up
		front = {},
		back = { position = Vector2(-1, -8), frame = 2, flip_h = false, flip_v = true }
	},
	{ #UpRight
		front = {},
		back = { position = Vector2(4, -7), frame = 1, flip_h = true, flip_v = true }
	},
	{ #Right
		front = { position = Vector2(9, -5), frame = 0, flip_h = true, flip_v = false },
		back = {}
	},
	{ #DownRight
		front = { position = Vector2(6, -4), frame = 1, flip_h = true, flip_v = false },
		back = {}
	},
	{ #Down
		front = { position = Vector2(-1, -3), frame = 2, flip_h = false, flip_v = false },
		back = {}
	},
	{ # DownLeft
		front = { position = Vector2( -6, -4), frame = 1, flip_h = false, flip_v = false },
		back = {}
	},
	{ #Left
		front = { position = Vector2(-9, -5), frame = 0, flip_h = false, flip_v = false },
		back = {}
	},
	{ #UpLeft
		front = {},
		back = { position = Vector2(-4, -7), frame = 1, flip_h = false, flip_v = true }
	}
]

const EYE_STATES = [
	#Up
	{left = {}, right = {} },
	#UpRight
	{left = {}, right = {} },
	#Right
	{
		left = {}, 
		right = {position = Vector2(2, -8)} 
	},
	#DownRight
	{
		left = {position = Vector2(-1, -7)}, 
		right = {position = Vector2(4, -8)} 
	},
	#Down
	{
		left = {position = Vector2(-4, -7)}, 
		right = {position = Vector2(3, -7)} 
	},
	#DownLeft
	{
		left = {position = Vector2(-5, -8)}, 
		right = {position = Vector2(0, -7)} 
	},
	#Left
	{
		left = {position = Vector2(-3, -8)}, 
		right = {} 
	},
	#UpLeft
	{ left = {},  right = {} }
]


func isCharacterSpriteHandler() -> bool: return true

func idle() -> void:
	anims.play("idle")


func run() -> void:
	
	anims.play("run")

func _updateBeakStates(data: Dictionary) -> void:

	$holder/front_beak.visible = data.front.size() > 0
	$holder/back_beak.visible = data.back.size() > 0

	if $holder/front_beak.visible:
		$holder/front_beak.position = data.front.position
		$holder/front_beak.frame = data.front.frame
		$holder/front_beak.flip_h = data.front.flip_h
		$holder/front_beak.flip_v = data.front.flip_v
	else:
		$holder/back_beak.position = data.back.position
		$holder/back_beak.frame = data.back.frame
		$holder/back_beak.flip_h = data.back.flip_h
		$holder/back_beak.flip_v = data.back.flip_v

func _updateEyeStates(data: Dictionary) -> void:

	$holder/leftEye.visible = data.left.size() > 0
	$holder/rightEye.visible = data.right.size() > 0

	if $holder/leftEye.visible:
		$holder/leftEye.position = data.left.position

	if $holder/rightEye.visible:
		$holder/rightEye.position = data.right.position
	

func _updateHandDrawOrder(hand) -> void:
	var is_back: bool = hand.position.normalized().dot(Vector2.DOWN) < 0.0

	if is_back and hand.get_index() > 2:
		$holder.move_child(hand, 0)
	elif not is_back and hand.get_index() < 2:
		$holder.move_child(hand, $holder.get_child_count() - 1)


func _process(delta):


	view_direction = get_local_mouse_position().normalized()

	var closest_dot:float = -1.0
	var closest_index:int = -1
	for direction in Directions:
		var current_dot:float = direction_list[Directions[direction]].dot(view_direction)
		
		if current_dot > closest_dot:
			closest_dot = current_dot
			closest_index = Directions[direction]
		

	_updateBeakStates(BEAK_STATES[closest_index])
	_updateEyeStates(EYE_STATES[closest_index])

	_updateHandDrawOrder($holder/leftHand)
	_updateHandDrawOrder($holder/rightHand)

	$holder/armsHolder.rotation = view_direction.angle() + PI/2.0