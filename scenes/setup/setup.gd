extends Control


func indicator(message: String, color: Color = Color(1, 0, 0)):
	$backround/indicator.add_color_override("font_color", color)
	$backround/indicator.text = message
	yield(get_tree().create_timer(2), "timeout")
	$backround/indicator.text = ''

# main:
func _on_icon_animation_finished(anim_name):
	$text_entry_1.grab_focus()

func _on_cancel_pressed():
	Global.change_scene(Global.get_previous_scene())

func _on_welcome_next_pressed():
	Global.change_scene('res://scenes/setup/name_email.tscn', true)

func _on_name_email_next_pressed():
	var te1 = $text_entry_1.text
	var te2 = $text_entry_2.text
	if len(te1.replace(' ', '')) < 4 or not ' ' in te1:
		indicator('Name must include both first and last name')
		$text_entry_1.grab_focus()
	elif len(te2) < 5 or ' ' in te2 or not '@' in te2 or not '.' in te2:
		indicator('Email looks to be invalid')
		$text_entry_2.grab_focus()
	else:
		Global.user_data['acc']['name'] = Global.strip(te1.capitalize().lstrip(' '), """!"#$%&'()*+,-./:;<=>?@[\n]^_`{|}~""")
		Global.user_data['acc']['email'] = te2
		Email.send_confirmation_email()
		Global.change_scene('res://scenes/setup/email_confirmation.tscn')



func _on_email_confirmation_next_pressed():
	var te1 = $text_entry_1
	if te1.text == Email.otp:
			Global.change_scene("res://scenes/setup/password.tscn")
	else:
		te1.clear()
		indicator("Code is incorrect")

func _on_otp_label_ready():
	$otp_label.text = Description.otp%Global.user_data["acc"]["email"]

func _on_resend_pressed():
	Email.refresh_otp()
	Email.send_confirmation_email()
	indicator('Email has been resent', Color(0, 1, 0))



func _on_password_next_pressed():
	var te1 = $text_entry_1.text
	var te2 = $text_entry_2.text
	if ' ' in te1:
		indicator('Password can not have any spaces')
	elif len(te1) < 6 or len(te2) < 6:
		indicator('Password must have (6) or more characters')
	elif te1 != te2:
		indicator('Passwords must match')
	else:
		Global.user_data['acc']['password'] = te2
		Global.change_scene('res://scenes/setup/question_answer.tscn')

var hidden_password: bool = true
func _on_hide_password_pressed():
	if hidden_password:
		$text_entry_1.secret = false
		$text_entry_2.secret = false
		hidden_password = false
	else:
		$text_entry_1.secret = true
		$text_entry_2.secret = true
		hidden_password = true


func _on_question_answer_next_pressed():
	var question: OptionButton = $text_entry_1
	var answer: String = $text_entry_2.text
	if question.selected == 0:
		indicator('Please select a question')
	elif ' ' in answer or answer == '':
		indicator('Answer must be (1) word only and connot have spaces')
	else:
		Global.user_data['acc']['question'] = question.text
		Global.user_data['acc']['answer'] = Global.strip(answer.to_lower(), """ !"#$%&'()*+,-./:;<=>?@[\n]^_`{|}~""")
		Global.user_data['acc']['exists'] = true
		Global.user_data['acc']['year'] = Time.get_date_dict_from_system()['year']  # used because new_year new setup does not renew the year so this needs to be done.
		Global.save_changes()
		Global.change_scene('res://scenes/setup/successful.tscn')

func _on_question_ready():
	$text_entry_1.get_child(0).mouse_default_cursor_shape = 2

func _on_successful_start_intro_pressed():
	Global.change_scene('res://scenes/setup/tutorial.tscn')

func _on_successful_import_done_pressed():
	Global.change_scene('res://scenes/base.tscn')

## Backup:
func _on_FileDialog_file_selected(path):
	Global.restore_account_from_file(path)
	var worked = Global.restore_account_from_file(path)
	if worked:
		Global.change_scene('res://scenes/setup/successful_restore.tscn')
	else:
		$file_corrupted.popup_centered()


func _on_restore_backup_pressed():
	$FileDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	$FileDialog.current_file = 'acja_web_viewer_account_data.save'
	$FileDialog.window_title = 'Import Account Data'
	$FileDialog.popup_centered()


func _on_file_corrupted_confirmed():
	_on_restore_backup_pressed()
