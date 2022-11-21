extends Control

func _ready():
	$pages/otp/otp_label.text = Description.otp%Global.user_data["acc"]["email"]
	$pages/question_answer/question.bbcode_text = "[center]%s[/center]"%Global.user_data["acc"]["question"]
	$pages/question_answer/answer.grab_focus()

func indicator(message: String, color: Color = Color(1, 0, 0), time: int = 2):
	$backround/indicator.add_color_override("font_color", color)
	$backround/indicator.text = message
	yield(get_tree().create_timer(time), "timeout")
	$backround/indicator.text = ''

var page: int = 0
func _on_continue_pressed():
	if page == 0:
		if Global.user_data["acc"]["answer"] == Global.strip($pages/question_answer/answer.text.to_lower(), """ !"#$%&"()*+,-./:;<=>?@[\n]^_`{|}~"""):
			$pages/AnimationPlayer.play("next_page")
			$pages/otp/otp_input.grab_focus()
			Email.send_recovery_email()
			page = 1
			
			# check the internet connection
			InternetConnection.check()
			yield(get_tree().create_timer(4), "timeout")  # give time for connection check
			if not InternetConnection.connection_status:
				indicator('Please connect to the internet and press resend', Color(1, 0, 0), 10)
		else:
			$pages/question_answer/answer.clear()
			indicator("Answer is incorrect")
	elif page == 1:
		if $pages/otp/otp_input.text == Email.otp:
			Global.change_scene("res://scenes/recovery/new_password.tscn")
		else:
			$pages/otp/otp_input.clear() 
			indicator("Code is incorrect")

func _on_resend_pressed():
	Email.refresh_otp()
	Email.send_recovery_email()
	indicator('Email has been resent', Color(0, 1, 0))

func _on_try_another_way_pressed():
	Global.change_scene("res://scenes/recovery/option_2.tscn")

func _on_cancel_pressed():
	Global.change_scene(Global.get_previous_scene())
