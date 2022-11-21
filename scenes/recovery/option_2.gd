extends Control

func _ready():
	$otp/otp_input.grab_focus()

func indicator(message: String, color: Color = Color(1, 0, 0)):
	$backround/indicator.add_color_override("font_color", color)
	$backround/indicator.text = message
	yield(get_tree().create_timer(2), "timeout")
	$backround/indicator.text = ''


# main:
func time_seed_generator():
	var t: Dictionary = Time.get_datetime_dict_from_system(true)
	var minute: int = t['minute'] - (t['minute'] % 5)  # this makes the code expire within 5 minutes.
	return '{1}{2}{3}{4}{5}'.format({1: minute, 2: t['hour'], 3: t['day'], 4: t['weekday'], 5: t['year']})

func rand_pin(seed_='', length=6) -> String:  # generates random pin that is used to unlock password
	var rg: RandomNumberGenerator = RandomNumberGenerator.new()
	rg.seed = (seed_ + Global.program_id).hash()
	var out: String = ''
	for i in range(length):
		out += str(rg.randi_range(0, 9))
	return out

func _on_continue_pressed():
	if $otp/otp_input.text == rand_pin(time_seed_generator()):
		Global.change_scene("res://scenes/recovery/new_password.tscn")
	else:
		$otp/otp_input.clear()
		indicator('Bypass code is incorrect')

func _on_try_another_way_pressed():
	Global.change_scene("res://scenes/recovery/recover_password.tscn")

func _on_cancel_pressed():
	# cancel is not working - bug
	Global.change_scene(Global.get_previous_scene())


func _on_otp_label_meta_hover_ended(meta):
	Global.change_scene("res://scenes/contact.tscn", true)
