extends CharacterBody3D

const SPEED = 5.0
const CROUCH_SPEED = 2.5
const JUMP_VELOCITY = 4.5
var playerMovement = SPEED

@onready var camera_point = $camera_point
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var animation_player = $Visuals/player/AnimationPlayer
@onready var visuals = $Visuals

var walking = false;
var crouching = false;

func _ready():
	GameManager.set_player(self)
	animation_player.set_blend_time("idle", "run", 0.5)
	animation_player.set_blend_time("run", "idle", 0.5)
	animation_player.set_blend_time("idle", "crouch_idle", 0.5)
	animation_player.set_blend_time("run", "crouch_walk", 0.5)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("crouch"):
		if crouching: 
			crouching = false
			playerMovement = SPEED
		else:
			crouching = true
			playerMovement = CROUCH_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * playerMovement
		velocity.z = direction.z * playerMovement
		walking = true
		visuals.look_at(direction + position)
		if !crouching:
			animation_player.play("run")
		else: 
			animation_player.play("crouch_walk")

	else:
		velocity.x = move_toward(velocity.x, 0, playerMovement)
		velocity.z = move_toward(velocity.z, 0, playerMovement)
		walking = false
		visuals
		if !crouching:
			animation_player.play("idle")
		else:
			animation_player.play("crouch_idle")

	move_and_slide()
