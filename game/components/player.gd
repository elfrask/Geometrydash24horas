extends CharacterBody2D

var MODES = Game.MODES

@export var INIT_MODE: Game.MODES = 0

var MODE = INIT_MODE

var gravity_orientation = 1

# modo 0
var RotationSnap = 0
var initSpeed = 1000
var speed = initSpeed
var gravity = 9.81*20
var jump = 2900
var startPoint: Vector2
var velocity_rotate = 6

var sueloTocado = false

@onready var ImageMode0: Node2D = $imgs/mode0/img
@onready var particlesMode0: GPUParticles2D = $imgs/mode0/particles


# mode 1

var gravity_mode1 = 9.81


@onready var modesVisualNodes = [$imgs/mode0, $imgs/mode1, $imgs/mode2, $imgs/modo3, $imgs/modo4]
@onready var modesCollisionNodes = [$mode0, $mode1, $mode2, $mode3, $mode4]
@onready var modesCollisionNodesArea = [$damagebox/damage_area/modo0, $damagebox/damage_area/modo1, $damagebox/damage_area/modo2, $damagebox/damage_area/modo3, $damagebox/damage_area/modo4]

func change_mode(mode: int):
	
	for i in range(0, 5):
		modesVisualNodes[i].visible = false
		modesCollisionNodes[i].disabled = true
		modesCollisionNodesArea[i].disabled = true
		pass
	if not mode == MODES.DIE:
		modesVisualNodes[mode].visible = true
		modesCollisionNodes[mode].disabled = false
		modesCollisionNodesArea[mode].disabled = false
	
	MODE = mode
	pass

func die():
	
	$die_ani.play("die")
	if MODE != Game.MODES.DIE:
		$explode.play(0)
	change_mode(MODES.DIE)
	
	
	pass

func _ready():
	startPoint = position
	change_mode(INIT_MODE)
	$die_ani.play("RESET")

func pin(obj: Node2D, obj2: Node2D):
	obj.position = obj2.position
	pass

func restart():
	$imgs.visible = true
	position = startPoint
	velocity = Vector2()
	change_mode(INIT_MODE)
	pincho_orientacion =1
	
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		restart()
	
	match MODE:
		0:
			mode0(delta)
			pass
		1:
			mode1(delta)
			pass
		2:
			mode2(delta)
			pass
		3:
			mode3(delta)
			pass
		4:
			mode4(delta)
			pass
		5:
			pass
		
	if velocity.x == 0:
		die()
		pass
	pass

func mode0(delta):
	
	velocity.x = speed
	velocity.y += gravity
	
	if Input.is_action_pressed("jump"):
		if $suelo.is_colliding():
			var coll_obj:Node2D = $suelo.get_collider()
			
			if coll_obj.is_in_group("solid"):
				velocity.y = -jump 
	
	if not $suelo.is_colliding() and sueloTocado:
		
		#ImageMode0.rotation_degrees += velocity_rotate
		ImageMode0.rotation += 6 * delta
		pass
	
	if $suelo.is_colliding():
		sueloTocado = true
		var lerpRotation = snapped(ImageMode0.rotation, PI / 2)
		ImageMode0.rotation = lerp_angle(ImageMode0.rotation, lerpRotation, delta*25)
		#ImageMode0.rotation = lerpRotation
		
		
	particlesMode0.emitting = $suelo.is_colliding()
	
	if $techo.is_colliding():
		var coll_obj:Node2D = $techo.get_collider()
			
		if coll_obj.is_in_group("solid"):
			die()
		pass
	
	move_and_slide()
	
	pass


func mode1(delta):
	var limits = 2500
	
	var force = -60
	velocity.x = speed
	
	
	if not Input.is_action_pressed("jump"):
		force = -force 
	
	
	velocity.y = clamp(velocity.y + force, -limits, limits) * gravity_orientation
	
	var torotation = (velocity.y / limits) # * gravity_orientation
	
	$imgs/mode1.rotation_degrees = torotation * 60
	$imgs/mode1.scale.y = gravity_orientation
	
	
	move_and_slide()
	pass
	
	
func mode2(delta):
	
	velocity.x = speed
	velocity.y += gravity * 0.6
	
	
	
	if Input.is_action_just_pressed("jump"):
		
		velocity.y = -jump*0.5
	
	var limit = 1500
	if velocity.y > limit:
		velocity.y = limit
	
	
	move_and_slide()
	pass

var pincho_orientacion = 1

func mode3(delta):
	
	var img:Sprite2D = $imgs/modo3
	velocity.x = speed
	
	img.rotation += 5 * delta * pincho_orientacion
	if Input.is_action_pressed("jump"):
		if $suelo.is_colliding():
			var coll_obj:Node2D = $suelo.get_collider()
			
			if coll_obj.is_in_group("solid"):
				if pincho_orientacion == 1:
					pincho_orientacion = -1
				else:
					pincho_orientacion = 1
		if $techo.is_colliding():
			var coll_obj:Node2D = $techo.get_collider()
			
			if coll_obj.is_in_group("solid"):
				if pincho_orientacion == 1:
					pincho_orientacion = -1
				else:
					pincho_orientacion = 1
		
	
	var limit = 2000
	
	velocity.y += gravity * 0.8 * pincho_orientacion
	velocity.y = clamp(velocity.y, -limit, limit)
	move_and_slide()
	
	pass

@export var long_trail: int = 30
@export var trail_node: NodePath 
var ListPointTrail: Array

func mode4(delta):
	
	velocity.x = speed
	velocity.y = 2000
	
	var force = 1
	
	if Input.is_action_pressed("jump"):
		force = -1
	
	velocity.y *= force
	
	var img:Sprite2D = $imgs/modo4/modo4
	
	move_and_slide()
	
	img.rotation_degrees = int(60 * force)
	
	if $suelo.is_colliding() or $techo.is_colliding():
		img.rotation_degrees = 0
	
	var line:Line2D = get_node(trail_node)
	
	ListPointTrail.push_front(position)
	
	if len(ListPointTrail) > long_trail:
		ListPointTrail.pop_back()
	
	line.clear_points()
	
	for i in ListPointTrail:
		line.add_point(i)
	
	
	pass

func insert_jump(_jump: float):
	
	match MODE:
		Game.MODES.CUBO:
			velocity.y = -_jump
			pass
		Game.MODES.NAVE:
			velocity.y = -_jump
			pass
		Game.MODES.OVNI:
			velocity.y = -_jump
			pass
		Game.MODES.PINCHOS:
			
			velocity.y = -_jump * pincho_orientacion
			pass
		Game.MODES.TRIANGULO:
			velocity.y = -_jump
			pass
		
	pass

func _on_damage_area_body_entered(body: Node2D):
	
	
	if body.is_in_group("damage"):
		die()
		pass
	pass # Replace with function body.


func _on_delay_timeout():
	print("reinicio")
	restart()
	pass # Replace with function body.
