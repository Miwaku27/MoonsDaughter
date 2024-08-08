extends Node

@export var player : Node3D

@export var camera_size := 20.0
@onready var camera = $SubViewportContainer/SubViewport/Camera3D


func _ready():
	camera.size = camera_size

func _process(_delta):
	camera.position = Vector3(player.position.x, camera_size, player.position.z)
	camera.rotation = Vector3(deg_to_rad(-90), player.rotation.y, 0)
