extends Control


func _ready():
	if not Global.user_data['acc']['exists']:  # checks to see if there is no account
		Global.change_scene('res://scenes/setup/welcome.tscn')
	if Global.is_new_year():  # checks to see if the year has changed... if so initiate new_teacher.tscn
		Global.change_scene("res://scenes/new_year.tscn")


# arrange buttons:
func button_arrange(buttons: Array, location: Array):
	var button_count = 0  # to loop through both buttons and location
	for loc in location:
		get_node('pages/' + buttons[button_count] + 'button_anim_loc').play(loc)
		button_count += 1

func _arrange_buttons_initiated():
	"""The first phase loop iterates through each button, reads from the files if 
	the button should be displayed and then adds what should be displayed to the 
	variable (buttons: array) and also adds the number of buttons that will be 
	displayed to the variable (button_count: int). The second phase checks for how
	many button have been allowed by using (button_count: int) and then uses the
	function (button_arrange(buttons: Array, location: Array)) to put them in their
	location accordingly."""
	
	# first phase: rearanging prep for each button
	var allowed_buttons: Array = []
	for button in ['browser', 'encyclopedia', 'khan_academy', 'typing', 'fun_educational_websites']:
		if not Global.user_data['hw'][button]:
			allowed_buttons.append(button + '/')
			get_node('pages/' + button).show()
		else:
			get_node('pages/' + button).hide()
		
	# second phase: rearranging
	var button_count: int = len(allowed_buttons)
	if button_count == 5:
		button_arrange(allowed_buttons, ['top_left', 'top_right', 'center', 'bottom_left', 'bottom_right'])
	elif button_count == 4:
		button_arrange(allowed_buttons, ['top_left', 'top_right', 'bottom_left', 'bottom_right'])
	elif button_count == 3:
		button_arrange(allowed_buttons, ['middle_left', 'center', 'middle_right'])
	elif button_count == 2:
		button_arrange(allowed_buttons, ['middle_center_left', 'middle_center_right'])
	elif button_count == 1:
		button_arrange(allowed_buttons, ['center'])
	
	# 2nd page - fun education websites:
	if Global.user_data['hw']['national_geographic']:
		$pages/fun_brain/button_anim_loc.play("center")
		$pages/national_geographic.hide()
	elif Global.user_data['hw']['fun_brain']:
		$pages/national_geographic/button_anim_loc.play('center')
		$pages/fun_brain.hide()
	else:
		$pages/national_geographic/button_anim_loc.play('left')
		$pages/fun_brain/button_anim_loc.play('right')
		$pages/national_geographic.show()
		$pages/fun_brain.show()


# button hover animation
func _on_mouse_entered():
	$button_anim_loc.play('button_animation')

func _on_mouse_exited():
	$button_anim_loc.play_backwards('button_animation')


# 2nd page init
func _on_fun_educational_websites_pressed():
	$pages/page_change.play('fun_educational_websites')
	$back/AnimationPlayer.play('back')
func _on_back_pressed():
	$pages/page_change.play_backwards('fun_educational_websites')
	$back/AnimationPlayer.play_backwards('back')


# teachers buttons
func _on_google_pressed():
	Global.last_restricted_button_pressed = 'google'
	Global.change_scene('res://scenes/password_wall.tscn')

func _on_settings_pressed():
	Global.last_restricted_button_pressed = 'settings'
	Global.change_scene('res://scenes/password_wall.tscn')

# website buttons
func button_pressed(button_name: String):
	if not Global.user_data['rw'][button_name]:
		Website.run(button_name)
	else:
		Global.last_restricted_button_pressed = button_name
		Global.change_scene('res://scenes/password_wall.tscn')

func _on_browser_pressed():
	button_pressed('browser')

func _on_encyclopedia_pressed():
	button_pressed('encyclopedia')

func _on_khan_academy_pressed():
	button_pressed('khan_academy')
	
func _on_typing_pressed():
	button_pressed('typing')

func _on_national_geographics_pressed():
	button_pressed('national_geographic')

func _on_fun_brain_pressed():
	button_pressed('fun_brain')


# added websites
func _on_added_websites_ready():
	var index: int = 0
	for website in Global.user_data['added']:
		$added_websites/added_websites.add_item(website['name'])
		$added_websites/added_websites.set_item_tooltip_enabled(index, false)
		index += 1
	
	if $added_websites/added_websites.get_item_count() != 0:
		$added/AnimationPlayer.play('added')

var show_added: bool = false
func _on_added_close_pressed():
	if show_added:
		$added_websites.hide()
	else:
		$added_websites.show()
	show_added = not show_added
	_on_added_websites_nothing_selected()

func _on_added_websites_nothing_selected():
	$added_websites/added_websites.unselect_all()


func _on_added_websites_item_activated(index):
	if not Global.user_data['added'][index]['rw']:
		Website.run_added_website(index)
		yield(get_tree().create_timer(0.5), "timeout")  # sleep(0.5)
		$added_websites/added_websites.unselect_all()
	else:
		Global.last_restricted_button_pressed = index
		Global.change_scene('res://scenes/password_wall.tscn')
	_on_added_close_pressed()
