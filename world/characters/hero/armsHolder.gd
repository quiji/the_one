tool
extends Node2D

var sword_anims: SwordAnims

export var body_node: NodePath

var fired_count: float = 0.0
var fire_wait: float = 0.0
var weapon: String = ''
var first_attack: bool = true

var body

func _ready():
	$left.position = Vector2(-12.0, 0.0)
	$right.position= Vector2(12.0, 0.0)

	if body_node and has_node(body_node):
		body = get_node(body_node)

	equipWeapon("hand", 2.0)

func equipWeapon(weapon_name: String, fire_rate: float) -> void:
	weapon = weapon_name
	fire_wait = 1.0 / fire_rate
	$anims.play("%s-start" % weapon)

func run()-> void:
	if $anims.has_animation("%s-run" % weapon):
		$anims.play("%s-run" % weapon)

func idle()-> void:
	if $anims.has_animation("%s-start" % weapon):
		$anims.play("%s-start" % weapon)
		

func _process(delta: float):
	if Engine.editor_hint:
		return

	
	if Input.is_action_just_pressed("throw"):
		GameData.projectiles.spawnSword(global_position + body.view_direction * 10.0, body.view_direction)

	if Input.is_action_pressed("attack") and fired_count > fire_wait:
		fired_count = 0.0

		if first_attack:
			$anims.play("%s-attack" % weapon) 
			$anims.queue("%s-attack-recover" % weapon) 
		else:
			$anims.play("%s-attack2" % weapon) 
			$anims.queue("%s-attack2-recover" % weapon) 
		
		first_attack = not first_attack

	fired_count += delta



func _physics_process(delta: float):

	var leftArm: Line2D = $left/leftArm.get_node($left/leftArm.remote_path)
	var rightArm: Line2D = $right/rightArm.get_node($right/rightArm.remote_path)

	leftArm.points[0] = Vector2.ZERO
	leftArm.points[1] = -leftArm.position * 0.2 + Vector2.UP * 4.0
	leftArm.points[2] = -leftArm.position + Vector2.UP * 6.0

	rightArm.points[0] = Vector2.ZERO
	rightArm.points[1] = -rightArm.position * 0.2 + Vector2.UP * 4.0
	rightArm.points[2] = -rightArm.position + Vector2.UP * 6.0
	
	
