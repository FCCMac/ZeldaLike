extends Camera2D

func _ready():
	$area.connect("body_entered", self, "body_entered")
	$area.connect("body_exited", self, "body_exited")

func _process(delta):
	var position = get_node("../player").global_position - Vector2(0, 16)
	var x = floor(position.x / 160) * 160
	var y = floor(position.y / 128) * 128
	global_position = Vector2(x, y)
	
func body_entered(body):
	if body.get("TYPE") == "ENEMY":
		body.set_physics_process(true)
	
func body_exited(body):
	if body.get("TYPE") == "ENEMY":
		body.set_physics_process(false)
