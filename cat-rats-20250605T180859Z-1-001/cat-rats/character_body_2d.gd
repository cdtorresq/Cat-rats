extends CharacterBody2D
var progress_ratio=0.0
var speed=0.05
func _process(delta):
	progress_ratio+=delta*speed
