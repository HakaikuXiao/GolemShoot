extends Node

@onready var  main : Node = get_tree().root.get_node("main")

@onready var data : Node = main.get_node("data")
@onready var levels : Node3D = main.get_node("levels")
@onready var players : Node3D = main.get_node("players")
@onready var ui : Control = main.get_node("ui")

var player : Node3D = null
var curr_level : Node3D = null
var lobby : Control = null
var main_menu : Control = null


func _ready() -> void:
	debug.log("Game started")
	
	player = preload("res://components/player/player.tscn").instantiate()
	curr_level = preload("res://components/levels/test/level.tscn").instantiate()
	lobby = preload("res://components/ui/lobby/lobby.tscn").instantiate()
	main_menu = preload("res://components/ui/main_menu/main_menu.tscn").instantiate()
	ui.add_child(main_menu)
	ui.add_child(lobby)
	debug.log("Main menu: " + str(main_menu) + "	" + "Lobby: " + str(main_menu))
