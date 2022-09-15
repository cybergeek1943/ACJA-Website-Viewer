extends Control


func indicator(message: String, color: Color):
	$question_answer/indicator.add_color_override('font_color', color)
	$question_answer/indicator.text = message


func _ready():
	$question_answer/question.text = Global.user_data['acc']['question']



func _on_cancel_pressed():
	get_tree().change_scene('res://windows/password_wall.tscn')

func _on_continue_pressed():
	if Global.user_data['acc']['answer'] in [Global.strip($question_answer/answer.text.to_lower(), """ !"#$%&'()*+,-./:;<=>?@[\n]^_`{|}~"""), 'vhu23@7s%jK-gx2$']:
		indicator('Answer is incorrect', Color(1, 0, 0, 1))
	else:
		$question_answer/answer.focus_mode = false
		$question_answer/continue.hide()
		$question_answer/cancel.hide()
		$try_another_way.hide()
		$done.show()
		indicator('Your password is:  ' + Global.user_data['acc']['password'], Color(0, 1, 0, 1))

func _on_done_pressed():
	get_tree().change_scene('res://windows/password_wall.tscn')

var method = 2
func _on_try_another_way_pressed():
	if method == 1:
		$question_answer.show()
		$method_2_3_text.hide()
		$done.hide()
		method = 2
	elif method == 2:
		$done.show()
		$method_2_3_text.show()
		$question_answer.hide()
		$method_2_3_text.text = Description.option_2.format({'1': Global.user_data['acc']['name'], '2': Global.user_data['acc']['email']})
		method = 3
	elif method == 3:
		$done.show()
		$method_2_3_text.show()
		$question_answer.hide()
		$method_2_3_text.text = Description.option_3
		method = 1
