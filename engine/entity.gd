extends KinematicBody2D

var TYPE = null
export var SPEED = 70
export var MAX_HEALTH = 2
export(float) var health

var movedir = Vector2(0, 0)
var knockdir = Vector2(0, 0)
var spritedir = "down"

var hitstun = 0

var texture_default = null
var texture_hurt = null

func _ready():
	texture_default = $Sprite.texture
	texture_hurt = load($Sprite.texture.get_path().replace(".png", "_hurt.png"))

func movement_loop():
	var motion
	
	if hitstun == 0:
		motion = movedir.normalized() * SPEED
	else:
		motion = knockdir.normalized() * 125
		
	# warning-ignore:return_value_discarded
	move_and_slide(motion, dir.center)
	
func spritedir_loop():
	match movedir:
		dir.left:
			spritedir = "left"
		dir.right:
			spritedir = "right"
		dir.up:
			spritedir = "up"
		dir.down:
			spritedir = "down"
			
func anim_switch(animation):
	var newanim = str(animation, "_",spritedir)
	if $anim.current_animation != newanim:
		$anim.play(newanim)
		
func damage_loop():
	health = min(MAX_HEALTH, health)
	if hitstun > 0:
		hitstun -= 1
		$Sprite.texture = texture_hurt
	else:
		$Sprite.texture = texture_default
		if TYPE == "ENEMY" && health <= 0:
			var drop = randi() % 3
			if drop == 0:
				instance_scene(preload("res://pickups/heart.tscn"))
			instance_scene(preload("res://enemies/enemy_death.tscn"))
			
			queue_free()
		
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		
		if hitstun == 0 && body.get("DAMAGE") != null && body.get("TYPE") != TYPE:
			health -= body.get("DAMAGE")
			hitstun = 10
			knockdir = global_transform.origin - body.global_transform.origin
	
func use_item(item):
	var new_item = item.instance()
	new_item.add_to_group(str(new_item.get_name(), self))
	add_child(new_item)
	if get_tree().get_nodes_in_group(new_item.get_name()).size() > new_item.max_amount:
		new_item.queue_free()
		
func instance_scene(scene):
	var new_scene = scene.instance()
	new_scene.global_position = global_position
	get_parent().add_child(new_scene)

