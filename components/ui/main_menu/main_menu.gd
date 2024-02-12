extends Control

var code : int = 0

func _on_play_pressed() -> void:
	debug.log("Show lobby")
	sys.lobby.show()


func _on_settings_pressed() -> void:
	debug.log("Show lobby")


func _on_quit_pressed() -> void:
	debug.log("Exit with code " + str(code))
	get_tree().quit(code)
