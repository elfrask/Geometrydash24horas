extends Area2D

@export var JUMP: Game.JUMPS 
# Called when the node enters the scene tree for the first time.

var ListPlayers: Array= []

func _ready():
	$sheet.frame = 0 + Game.JUMPS_COLOR_ORDENING[JUMP]
	pass # Replace with function body.

func _process(delta):
	
	if Input.is_action_just_pressed("jump"):
		
		for i in ListPlayers:
			i.insert_jump(Game.JUMPS_FORCE_ORDENING[JUMP] * 0.75)
			$particles.emitting = true
			
			pass
		pass
	
	pass

func _on_body_entered(body: Node2D):
	
	
	if body.is_in_group("player"):
		
		ListPlayers.append(body)
		
		pass
	pass
	


func _on_body_exited(body: Node2D):
	
	if body.is_in_group("player"):
		
		ListPlayers.erase(body)
		
		pass
	pass # Replace with function body.
