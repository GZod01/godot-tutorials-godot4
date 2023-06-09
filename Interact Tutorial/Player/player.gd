class_name Player
extends CharacterBody3D

@export var speed = 10
@export var accel = 10
@export var gravity = 50
@export var jump = 15
@export var sensitivity = 0.2
@export var max_angle = 90
@export var min_angle = -80

@onready var head = $Head

var look_rot = Vector3.ZERO
var move_dir = Vector3.ZERO
var looking = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	#set rotation
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump
	
	move_dir = Vector3(
		Input.get_axis("left", "right"),
		0,
		Input.get_axis("forward", "backward")
	).normalized().rotated(Vector3.UP, rotation.y)
	
	velocity.x = lerp(velocity.x, move_dir.x * speed, accel * delta)
	velocity.z = lerp(velocity.z, move_dir.z * speed, accel * delta)
	
	set_velocity(velocity)
	# TODOConverter40 looks that snap in Godot 4.0 is float, not vector like in Godot 3 - previous value `Vector3.UP`
	set_up_direction(Vector3.UP)
	move_and_slide()
	velocity = velocity


func _input(event):
	if looking and event is InputEventMouseMotion:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)


# Ice Block code
func _on_ice_rotation_started():
	looking = false


func _on_ice_rotation_ended():
	looking = true
