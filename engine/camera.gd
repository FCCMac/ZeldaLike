extends Camera2D

const SCREEN_SIZE = Vector2(160, 128)
const HUD_THICKNESS = 16

var grid_pos = Vector2(0, 0)

func _ready():
	$area.connect("body_entered", self, "body_entered")
	$area.connect("body_exited", self, "body_exited")
	$area.connect("area_exited", self, "area_exited")

func _process(_delta):
	var player_grid_pos = get_grid_pos(get_node("../player").global_position)
	global_position = player_grid_pos * SCREEN_SIZE
	grid_pos = player_grid_pos
	
func get_grid_pos(pos):
	pos.y -= HUD_THICKNESS
	var x = floor(pos.x / SCREEN_SIZE.x)
	var y = floor(pos.y / SCREEN_SIZE.y)
	return Vector2(x, y)
	
func get_enemies():
	var enemies = []
	for body in $area.get_overlapping_bodies():
		if body.get("TYPE") == "ENEMY" && enemies.find(body) == -1:
			enemies.append(body)
			
	return enemies.size()
	
func body_entered(body):
	if body.get("TYPE") == "ENEMY":
		body.set_physics_process(true)
	
func body_exited(body):
	if body.get("TYPE") == "ENEMY":
		body.set_physics_process(false)
		
func area_exited(area):
	if area.get("disappears") == true:
		area.queue_free()

