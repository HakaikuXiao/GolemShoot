extends Control

@onready var text: Label = $text

func _physics_process(_delta: float) -> void:
	text.text = ("FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)))
