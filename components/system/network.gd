extends Node

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const port = 8882
const default_ip = "localhost"

var players = {}
var player_info = {"name": "Name"}

var players_loaded = 0

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	debug.log("Network setup success")


func join_game(address = ""):
	if address.is_empty():
		address = default_ip
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)
	if error:
		debug.err("Cannot create client!")

	multiplayer.multiplayer_peer = peer
	debug.log(str(peer) + " Joined to " + str(address) + ":" + str(port))


func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port)
	if error:
		debug.err("Cannot create server!")
	multiplayer.multiplayer_peer = peer

	players[1] = player_info
	player_connected.emit(1, player_info)
	debug.log(str(peer) + " Created server on " + str(port))


func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null
	debug.log("Peer removed")


func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)
	debug.log("Player " + str(id) + " connected.")


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)
	debug.log("Player " + str(new_player_info) + " registered")


func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)
	debug.log("Player " + str(id) + " disconnected.")


func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)
	debug.log("Connection is ok")


func _on_connected_fail():
	multiplayer.multiplayer_peer = null
	debug.log("Connection failed")


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
	debug.log("Server disconnected")
	


@rpc("call_local", "reliable")
func load_game(game_scene_path):
	get_tree().change_scene_to_file(game_scene_path)
	debug.log("Loaded " + game_scene_path + " level")


@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			$/root/main.start_game()
			players_loaded = 0
