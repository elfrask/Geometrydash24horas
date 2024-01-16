extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	
	$AnimationPlayer.play("play")
	$play_sound.play()
	$menu.stop()
	
	pass # Replace with function body.


func play():
	get_tree().change_scene_to_file("res://Levels/uniquelevel.tscn")
	pass
