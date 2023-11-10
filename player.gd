extends CharacterBody2D

#var edalta

const SPEED = 300.0
var chatopen = false
@export var trivia_scn : PackedScene
var trivia_instance
var in_area = false



func _enter_tree():
	set_multiplayer_authority(name.to_int())
	$ChatBox.visible = false
	$Box.visible = false
	$player_name.visible = false

	
func _ready():
	if is_multiplayer_authority():
		$Namelabel.visible = true

func _physics_process(delta):
	#edalta = delta
	if is_multiplayer_authority() and not chatopen:
		var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = input_direction * SPEED
		if input_direction.x > 0:
			$AnimatedSprite2D.play("nushc-sideways")
			$AnimatedSprite2D.flip_h = false
		if input_direction.x < 0:
			$AnimatedSprite2D.play("nushc-sideways")
			$AnimatedSprite2D.flip_h = true
		if input_direction.y > 0:
			$AnimatedSprite2D.play("nushc-downwards")
			$AnimatedSprite2D.flip_h = false
		if input_direction == Vector2.ZERO:
			$AnimatedSprite2D.stop()
		if Input.is_action_pressed("exit"):
			$"../".exit_game(name)
		move_and_slide()
		$Camera2D.make_current()
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("attack") and in_area:
			trivia_instance = trivia_scn.instantiate()
			add_child(trivia_instance)
			chatopen = true
			trivia_instance.position = position
	if trivia_instance != null:
		if is_multiplayer_authority() and trivia_instance.get_node('Control').trivia_timeout:
			$Box/Label.text = "My Score: "+str(trivia_instance.get_node('Control').score)
			$Box.visible = true
			chatopen = false
			$Timer.start()
			trivia_instance.queue_free()
		
func _input(event): 
	if is_multiplayer_authority():
		if Input.is_action_just_pressed('chat_open'):
			$ChatBox.visible = true
			chatopen = true
		if Input.is_action_just_pressed('ui_cancel') and $ChatBox.visible:
			$ChatBox.visible = false
			chatopen = false
			

"""
@rpc("unreliable", "any_peer", "call_local") func update_pos(id, pos):
	if !is_multiplayer_authority():
		if name == id:
			position = lerp(position, pos, edalta * 15)
	
func _on_timer_timeout():
	if is_multiplayer_authority():
		rpc("update_pos", name, position)
"""


func _on_line_edit_text_submitted(new_text):
	$Box/Label.text = new_text
	$ChatBox.visible = false
	$Box.visible = true
	chatopen = false
	$ChatBox/LineEdit.text = ""
	$Timer.start()


func _on_timer_timeout():
	$Box.visible = false
	$Timer.stop()

func _on_namelabel_text_submitted(new_text):
	$player_name.visible=true
	$player_name.text = new_text
	$Namelabel.visible = false


func _on_area_2d_body_entered(body):
	if(body.get_node('player_name') != null):
		in_area = true


func _on_area_2d_body_exited(body):
	in_area = false
