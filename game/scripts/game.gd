extends Node

enum MODES {
	CUBO,
	NAVE,
	OVNI,
	PINCHOS,
	TRIANGULO,
	DIE
}

enum JUMPS {
	RED,
	YELLOW,
	PURPLE
}

var JUMPS_COLOR_ORDENING = [0, 2, 4]
var JUMPS_FORCE_ORDENING = [3200, 4000, 5000]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
