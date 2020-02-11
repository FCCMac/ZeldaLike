extends Node2D

var TYPE = null
var DAMAGE = 1

var max_amount = 1

func _ready():
	TYPE = get_parent().TYPE
	$anim.connect("animation_finished", self, "destroy")
	$anim.play(str("swing_",get_parent().spritedir))
	
	if get_parent().has_method("state_swing"):
		get_parent().state = "swing"
	
func destroy(animation):
	if get_parent().has_method("state_swing"):
		get_parent().state = "default"
	
	queue_free()	
