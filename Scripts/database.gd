extends Node

var entities : Dictionary

func _ready():
	var path = "res://Resources/Entities/"
	for filePath in DirAccess.get_files_at(path):
		var entity = load(path + filePath)
		if entity.id:
			entities[entity.id] = entity

	path = "res://Resources/Items/"
	for filePath in DirAccess.get_files_at(path):
		var entity = load(path + filePath)
		if entity.id:
			entities[entity.id] = entity
