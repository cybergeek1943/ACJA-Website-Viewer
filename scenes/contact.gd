extends Control


func _ready():
	$pages/form/phone_input.grab_focus()
	
	
	# this is because TextEdit themeing does not work with any thing that goes outside of its rect (like a shadow)... this is because clipping is forced to always be true
	# this might be fixed in future versions of godot 4.x
	var unfocused_style_box: StyleBoxFlat = $pages/form/input_focus_shadow.get_stylebox('panel')
	var focused_style_box: StyleBoxFlat = unfocused_style_box.duplicate()
	focused_style_box.shadow_color = Color(0.215686, 0.72549, 0.862745)
	$pages/form/problem_input.connect("focus_entered", $pages/form/input_focus_shadow, "add_stylebox_override", ['panel', focused_style_box])
	$pages/form/problem_input.connect("focus_exited", $pages/form/input_focus_shadow, "add_stylebox_override", ['panel', unfocused_style_box])
	
	
	# check internet connection
	InternetConnection.check()
	yield(get_tree().create_timer(4), "timeout")  # give time for connection check
	if not InternetConnection.connection_status:
		indicator('Please connect to the internet', Color(1, 0, 0), 10)
	
	

func indicator(message: String, color: Color = Color(1, 0, 0), time: int = 2):
	$backround/indicator.add_color_override("font_color", color)
	$backround/indicator.text = message
	yield(get_tree().create_timer(time), "timeout")
	$backround/indicator.text = ''


func _on_label_meta_hover_started(meta):
	$pages/form/label.hint_tooltip = meta

func _on_label_meta_hover_ended(meta):
	$pages/form/label.hint_tooltip = ''

func _on_label_meta_clicked(meta):
	OS.clipboard = meta
	indicator('Copied to clipboard', Color(0, 1, 0))


# limit the amount that can be typed into problem_input
func _on_problem_input_text_changed():
	var input: TextEdit = $pages/form/problem_input
	var text_length: int = len(input.text)
	if text_length > 500:
		input.text = input.text.trim_suffix(input.text[-1])
		input.cursor_set_line(input.get_line_count())
		input.cursor_set_column(text_length)
		indicator('500 characters is to long')



func _on_send_pressed():
	var phone: LineEdit = $pages/form/phone_input
	var problem: TextEdit = $pages/form/problem_input
	if len(phone.text) < 8 or not Global.string_only_contains(phone.text, '()+- 1234567890'):
		phone.grab_focus()
		indicator('Please enter a valid phone number')
	elif not len(problem.text) > 20:
		problem.grab_focus()
		indicator('Please be more descriptive')
	else:
		# send email
		var body: String = """User Name: %s
User Email: %s
User Phone: %s

Problem Description:
%s"""%[Global.user_data['acc']['name'], Global.user_data['acc']['email'], phone.text, problem.text]
		
		Email.send_email('User Problem', body, Global.program_google_account)  # send_email() needs to give some feedback if it if was sent successfully
		
		# switch pages
		$pages/AnimationPlayer.play("next_page")
		$cancel/AnimationPlayer.play("hide")
		$backround/title.text = 'Message Submitted'
		

func _on_cancel_pressed():
	Global.change_scene(Global.get_previous_scene())

func _on_done_pressed():
	_on_cancel_pressed()
