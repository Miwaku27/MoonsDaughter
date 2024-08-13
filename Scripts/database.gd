extends Node

var entities : Dictionary
var abilities : Dictionary

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

	path = "res://Resources/Abilities/"
	for filePath in DirAccess.get_files_at(path):
		var ability = load(path + filePath)
		if ability.id:
			abilities[ability.id] = ability
