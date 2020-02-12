extends "res://engine/entity.gd"

var movetimer_length = 15
var movetimer = 0
var DAMAGE = 0.5

func _init():
	SPEED = 40
	TYPE = "ENEMY"
	MAX_HEALTH = 2
	health = MAX_HEALTH
	
func _ready():
	set_collision_mask_bit(1, 1)
	set_physics_process(false)
	$anim.play("default")
	movedir = dir.rand()

func _physics_process(delta):
	#movement_loop()
	damage_loop()
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0 || is_on_wall():
		movedir = dir.rand()
		movetimer = movetimer_length
