extends Area2D

@export var JUMP: Game.JUMPS 
# Called when the node enters the scene tree for the first time.

func _ready():
	$sheet.frame = 10 + Game.JUMPS_COLOR_ORDENING[JUMP]
	pass # Replace with function body.



func _on_body_entered(body: Node2D):
	
	
	if body.is_in_group("player"):
		
		body.insert_jump(Game.JUMPS_FORCE_ORDENING[JUMP])
		
		pass
	pass # Replace with function body.
