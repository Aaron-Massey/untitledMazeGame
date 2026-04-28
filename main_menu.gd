extends Control

const MAIN_SCENE := preload("res://main.tscn")

@export var start: Button
@export var options: Button
@export var exit: Button

func _ready():
		start.button_down.connect(on_start_press)
		exit.button_down.connect(on_exit_press)
	
func on_start_press():
	get_tree().change_scene_to_file("res://main.tscn")
	
func on_exit_press():
	get_tree().quit()
