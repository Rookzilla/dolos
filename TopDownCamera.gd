extends Camera

# Target to follow (player node)
nready var player = get_node("/root/MainScene/Player")  # Adjust path as per your scene structure

func _process(delta):
	if player:
		global_transform.origin = player.global_transform.origin
