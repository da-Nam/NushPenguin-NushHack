extends Control
var question_label: Label
var answer_buttons: Array
var correct_answer: String
var score: int = 0
var timer: Timer

var trivia_timeout = false
# Called when the node enters the scene tree for the first time.
func _ready():
	question_label = $Label
	answer_buttons = [$Button, $Button2, $Button3, $Button4]
	$ColorRect2.visible = false
	timer = $Timer
	$Label3.visible = true
	$Label4.visible = true
	$Label5.visible = true
	trivia_timeout = false
	random_question()
	

func random_question():
	var json_path = "res://allquestions.json"
	var json_data = load_json_file(json_path)
	if json_data != null:
		var questions = json_data.get("questions")
		if questions != null and questions.size() > 0:
			var random_question = questions[randi() % questions.size()]
			var question_text = random_question["question"]
			var answers = random_question["answers"]
			question_label.set_text(question_text)
			if answers != null and answers.size() == answer_buttons.size():
				for i in range(answer_buttons.size()):
					answer_buttons[i].text = answers[i]
				correct_answer = random_question["correct_answer"]
			else:
				print("Answers not properly formatted in the JSON.")
		else:
			print("No questions found in the JSON.")
	else:
		print("Failed to load JSON data.")


func check(answer_index: int):
	$ColorRect2.visible = true
	var selected_answer = answer_buttons[answer_index].text
	if selected_answer == correct_answer:
		score += 2
		# Update score display or perform other actions
		$ColorRect2.color = '#00FF00'
		$Label4.text = "+2"
		$Label5.text = "Your Score: " + str(score)
		random_question()
	else:
		score -= 1
		$ColorRect2.color = '#FF0000'
		$Label4.text = "-1"
		# Handle incorrect answer
		$Label5.text = "Your Score: " + str(score)
		random_question()
	if score < 0:
		$Label5.modulate = Color(1,0,0,1)  # Red color for negative score
	elif score == 0:
		$Label5.modulate = Color(1,1,0,1)  # Yellow color for zero score
	else:
		$Label5.modulate = Color(0,1,0,1)  # Green color for positive score
			
func load_json_file(filePath : String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath,FileAccess.READ)
		return JSON.parse_string(dataFile.get_as_text())
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label3.text = str(int(timer.time_left))

func get_score():
	print('hihi')
func get_trivia_timeout():
	return trivia_timeout

func _on_timer_timeout():
	timer.stop()
	print("Score:", score)
	$Label3.visible = false
	$Label4.visible = false
	$Label5.visible = false
	$ColorRect2.visible = false
	trivia_timeout = true



func _on_button_pressed():
	check(0)


func _on_button_2_pressed():
	check(1)


func _on_button_3_pressed():
	check(2)


func _on_button_4_pressed():
	check(3)
