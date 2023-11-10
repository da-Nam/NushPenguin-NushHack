extends Control


var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
var address_text
var port
var username


func _ready():
	enable_menu()
	address_text = $ColorBack/VBoxContainer/portlabel.text.split(':')[0]
	port = $ColorBack/VBoxContainer/portlabel.text.split(':')[1]


func _process(delta):
	pass

func _on_host_pressed():
	peer.create_server(int(port))
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	remove_menu()
	_add_player()
	
	

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func del_player(id):
	rpc("_del_player", id)


func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)
	get_tree().reload_current_scene()

	
	
@rpc("any_peer", "call_local") func _del_player(id):
	if  get_node(str(id)) != null:
		get_node(str(id)).queue_free()


func _on_join_pressed():
	peer.create_client(address_text,int(port))
	multiplayer.multiplayer_peer = peer
	remove_menu()


func remove_menu():
	$ColorBack.visible = false
func enable_menu():
	$ColorBack.visible = true
	
func _on_portlabel_text_changed():
	address_text = $ColorBack/VBoxContainer/portlabel.text.split(':')[0]
	port = $ColorBack/VBoxContainer/portlabel.text.split(':')[1]
