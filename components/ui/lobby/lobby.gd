extends Control

@onready var ip: LineEdit = $buttons/ip


func _on_create_pressed() -> void:
	net.create_game()


func _on_connect_pressed() -> void:
	net.join_game(ip.text)
