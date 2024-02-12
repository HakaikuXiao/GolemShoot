class_name debug
extends Node

static func log(text: String):
	print("[" + str(Time.get_time_string_from_system()) + "] " + text)


static func err(text: String):
	push_error("[" + str(Time.get_time_string_from_system()) + "] " + text)
	OS.alert(text, "ERROR")

static func warn(text: String):
	push_warning("[" + str(Time.get_time_string_from_system()) + "] " + text)
