extends Label


func set_data(account: String, message: String):
	text = "(" + str(account) + ")" + " " + str(message)
