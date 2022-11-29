extends Control


# 	indicator - loacated at bottom of window
# default time
const INDICATOR_DISPLAY_TIME: int = 2
const RED_COLOR: Color = Color(1, 0, 0)
const GREEN_COLOR: Color = Color(0, 1, 0)
func indicator(message: String, color: Color, time: float = INDICATOR_DISPLAY_TIME):
	get_node('backround/indicator').add_color_override('font_color', color)
	$backround/indicator.text = message
	$backround/indicator/timer.wait_time = time
	$backround/indicator/timer.start()

func _on_Timer_timeout():
	$backround/indicator.text = ''
	$backround/indicator/timer.stop()



# 	confirmaton diolog
var confirm_action: String = 'null'
func _on_ConfirmationDialog_confirmed():
	if confirm_action == 'exit':
		Global.save_changes()
		get_tree().quit()
	elif confirm_action == 'back':
		Global.save_changes()
		Global.change_scene("res://scenes/base.tscn")
	elif confirm_action == 'import':
		$FileDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
		$FileDialog.current_file = 'acja_web_viewer_account_data.save'
		$FileDialog.mode = FileDialog.MODE_OPEN_FILE
		$FileDialog.window_title = 'Import Account Data'
		$FileDialog.popup_centered()
	elif confirm_action == 'reset':
		Global.reset_account_and_settings()
		Global.change_scene("res://scenes/base.tscn")
	elif confirm_action == 'uninstall':
		pass

func confirmation_diolog(message: String, action: String):
	confirm_action = action
	$ConfirmationDialog.dialog_text = message
	$ConfirmationDialog.popup_centered()


# initializes window
func _ready():
	# account_information
	$sub_window/account_information/name.text = Global.user_data['acc']['name']
	$sub_window/account_information/email.text = Global.user_data['acc']['email']
	$sub_window/account_information/password.text = Global.user_data['acc']['password']
	$sub_window/account_information/question.text = Global.user_data['acc']['question']
	$sub_window/account_information/answer.text = Global.user_data['acc']['answer']
	# restrict websites
	$sub_window/restrict_websites/browser/browser.pressed = Global.user_data['rw']['browser']
	$sub_window/restrict_websites/encyclopedia/encyclopedia.pressed = Global.user_data['rw']['encyclopedia']
	$sub_window/restrict_websites/khan_academy/khan_academy.pressed = Global.user_data['rw']['khan_academy']
	$sub_window/restrict_websites/typing/typing.pressed = Global.user_data['rw']['typing']
	$sub_window/restrict_websites/national_geographic/national_geographic.pressed = Global.user_data['rw']['national_geographic']
	$sub_window/restrict_websites/fun_brain/fun_brain.pressed = Global.user_data['rw']['fun_brain']
	# hide websites
	$sub_window/remove_websites/browser/browser.pressed = Global.user_data['hw']['browser']
	$sub_window/remove_websites/encyclopedia/encyclopedia.pressed = Global.user_data['hw']['encyclopedia']
	$sub_window/remove_websites/khan_academy/khan_academy.pressed = Global.user_data['hw']['khan_academy']
	$sub_window/remove_websites/typing/typing.pressed = Global.user_data['hw']['typing']
	$sub_window/remove_websites/few_link/few_link.pressed = Global.user_data['hw']['fun_educational_websites']
	$sub_window/remove_websites/national_geographic/national_geographic.pressed = Global.user_data['hw']['national_geographic']
	$sub_window/remove_websites/fun_brain/fun_brain.pressed = Global.user_data['hw']['fun_brain']
	
	# for the "focus" of each side menu button. this starts on `account` hence the index is 0.
	_emulate_focus_button(0)

# exits program
func _on_exit_pressed():
	confirmation_diolog('Are you sure you want to exit?', 'exit')

# goes back to base window
func _on_back_to_base_pressed():
	confirmation_diolog('Are you sure you want to back to the home page?', 'back')


# menu buttons
func _emulate_focus_button(index: int): # make this so that a real <focus> is used on its own layer when 4.0 comes out!
	var buttons: Array = ['account_information', 'restrict_websites', 'remove_websites', 'add_websites', 'transfer_account',  'reset_uninstall', 'about']
	var i: int = 0
	for b in buttons:
		if i == index:
			var focus_style_box = get_node('menu_buttons/' + b).theme.get_stylebox('focus', 'Button')
			get_node('menu_buttons/' + b).add_stylebox_override('normal', focus_style_box)
		else:
			get_node('menu_buttons/' + b).remove_stylebox_override('normal')
		i += 1


func _on_account_information_pressed():
	_emulate_focus_button(0)
	$menu_buttons/button_indicator/AnimationPlayer.play('account_information')
	$sub_window/AnimationPlayer.play('account_information')

func _on_restrict_websites_pressed():
	_emulate_focus_button(1)
	$menu_buttons/button_indicator/AnimationPlayer.play('restrict_websites')
	$sub_window/AnimationPlayer.play('restrict_websites')

func _on_remove_websites_pressed():
	_emulate_focus_button(2)
	$menu_buttons/button_indicator/AnimationPlayer.play('remove_websites')
	$sub_window/AnimationPlayer.play('remove_websites')

func _on_add_websites_pressed():
	_emulate_focus_button(3)
	$menu_buttons/button_indicator/AnimationPlayer.play('add_websites')
	$sub_window/AnimationPlayer.play('add_websites')

func _on_transfer_account_pressed():
	_emulate_focus_button(4)
	$menu_buttons/button_indicator/AnimationPlayer.play('transfer_account')
	$sub_window/AnimationPlayer.play('transfer_account')

func _on_reset_uninstall_pressed():
	_emulate_focus_button(5)
	$menu_buttons/button_indicator/AnimationPlayer.play('reset_uninstall')
	$sub_window/AnimationPlayer.play('reset_uninstall')

func _on_about_pressed():
	_emulate_focus_button(6)
	$menu_buttons/button_indicator/AnimationPlayer.play('about')
	$sub_window/AnimationPlayer.play('about')


# sub_window: description
var description_back_mode: String = 'null'
func _on_back_pressed():
	$sub_window/AnimationPlayer.play(description_back_mode)

func _on_description_1_pressed():
	$sub_window/AnimationPlayer.play('description')
	$sub_window/description/description_label.text = 'Account Information  >  Description'
	$sub_window/description/description_backround/text.text = Description.acc
	description_back_mode = 'account_information'

func _on_description_2_pressed():
	$sub_window/AnimationPlayer.play('description')
	$sub_window/description/description_label.text = 'Restrict Websites  >  Description'
	$sub_window/description/description_backround/text.text = Description.rw
	description_back_mode = 'restrict_websites'

func _on_description_3_pressed():
	$sub_window/AnimationPlayer.play('description')
	$sub_window/description/description_label.text = 'Remove Websites  >  Description'
	$sub_window/description/description_backround/text.text = Description.hw
	description_back_mode = 'remove_websites'

func _on_description_4_pressed():
	$sub_window/AnimationPlayer.play('description')
	$sub_window/description/description_label.text = 'Add Websites  >  Description'
	$sub_window/description/description_backround/text.text = Description.aw
	description_back_mode = 'add_websites'

func _on_description_5_pressed():
	$sub_window/AnimationPlayer.play('description')
	$sub_window/description/description_label.text = 'Transfer Account  >  Description'
	$sub_window/description/description_backround/text.text = Description.ta
	description_back_mode = 'transfer_account'

func _on_description_6_pressed():
	$sub_window/AnimationPlayer.play('description')
	$sub_window/description/description_label.text = 'Reset & Uninstall  >  Description'
	$sub_window/description/description_backround/text.text = Description.ru
	description_back_mode = 'reset_uninstall'



# 		sub-window: account_information
# name confirm button
func _on_name_confirm_pressed():
	var name = $sub_window/account_information/name.text
	if len(name.replace(' ', '')) < 4 or not ' ' in name:
		indicator('Name must include both first and last name', RED_COLOR)
	else:
		indicator('Name is comfirmed', GREEN_COLOR)
		Global.user_data['acc']['name'] = Global.strip(name.capitalize().lstrip(' '), """!"#$%&'()*+,-./:;<=>?@[\n]^_`{|}~""")
		$sub_window/account_information/name.release_focus()

func _on_name_focus_entered():
	$sub_window/account_information/name/name_confirm/AnimationPlayer.play('fade')
	$sub_window/account_information/name/name_confirm.show()

func _on_name_focus_exited():
	$sub_window/account_information/name.text = Global.user_data['acc']['name']
	$sub_window/account_information/name/name_confirm/AnimationPlayer.play_backwards('fade')
	$sub_window/account_information/name/name_confirm.hide()
	

# email confirm button
func _on_email_confirm_pressed():
	var email = $sub_window/account_information/email.text
	if len(email) < 5 or ' ' in email or not '@' in email or not '.' in email:
		indicator('Email is invalid', RED_COLOR)
	else:
		indicator('Email is comfirmed', GREEN_COLOR)
		Global.user_data['acc']['email'] = email
		$sub_window/account_information/email.release_focus()

func _on_email_focus_entered():
	$sub_window/account_information/email/email_confirm.show()
	$sub_window/account_information/email/email_confirm/AnimationPlayer.play('fade')

func _on_email_focus_exited():
	$sub_window/account_information/email.text = Global.user_data['acc']['email']
	$sub_window/account_information/email/email_confirm/AnimationPlayer.play_backwards('fade')
	$sub_window/account_information/email/email_confirm.hide()

# 	password confirm button
func _on_pasword_confirm_pressed():
	var password = $sub_window/account_information/password.text
	if ' ' in password:
		indicator('Password can not have any spaces', RED_COLOR)
	elif len(password) < 6:
		indicator('Password must have (6) or more characters', RED_COLOR)
	else:
		indicator('Password is comfirmed', GREEN_COLOR)
		Global.user_data['acc']['password'] = password
		$sub_window/account_information/password.release_focus()

func _on_password_focus_entered():
	$sub_window/account_information/password/password_confirm.show()
	$sub_window/account_information/password/password_confirm/AnimationPlayer.play('fade')

func _on_password_focus_exited():
	$sub_window/account_information/password.text = Global.user_data['acc']['password']
	$sub_window/account_information/password/password_confirm/AnimationPlayer.play_backwards('fade')
	$sub_window/account_information/password/password_confirm.hide()

# question confirm
func _on_question_item_selected(index): # index is not used
	var question = $sub_window/account_information/question.text
	if len(question.split(' ')) < 2:
		indicator('Question must have (2) or more words', RED_COLOR)  
	else:
		indicator('Question is confirmed', GREEN_COLOR)
		Global.user_data['acc']['question'] = Global.strip(question, """!"#$%&'()*+,-./:;<=>?@[\n]^_`{|}~""") + '?'
		$sub_window/account_information/question.release_focus()

func _on_question_ready():
	$sub_window/account_information/question.get_child(0).mouse_default_cursor_shape = 2


# answer confirm
func _on_answer_confirm_pressed():
	var answer = $sub_window/account_information/answer.text
	if ' ' in answer or answer == '':
		indicator('Answer must be (1) word only and connot have spaces', RED_COLOR)
	else:
		indicator('Answer is comfirmed', GREEN_COLOR)
		Global.user_data['acc']['answer'] = Global.strip(answer.to_lower(), """!"#$%&'()*+,-./:;<=>?@[\n]^_`{|}~""")
		$sub_window/account_information/answer.release_focus()

func _on_answer_focus_entered():
	$sub_window/account_information/answer/answer_confirm.show()
	$sub_window/account_information/answer/answer_confirm/AnimationPlayer.play('fade')

func _on_answer_focus_exited():
	$sub_window/account_information/answer.text = Global.user_data['acc']['answer']
	$sub_window/account_information/answer/answer_confirm/AnimationPlayer.play_backwards('fade')
	$sub_window/account_information/answer/answer_confirm.hide()



# 	sub-window: restricted websites
# browser
func _on_browser_toggled(button_pressed):
	Global.user_data['rw']['browser'] = button_pressed

# encyclopedia
func _on_encyclopedia_toggled(button_pressed):
	Global.user_data['rw']['encyclopedia'] = button_pressed

# khan academy
func _on_khan_academy_toggled(button_pressed):
	Global.user_data['rw']['khan_academy'] = button_pressed

# typing
func _on_typing_toggled(button_pressed):
	Global.user_data['rw']['typing'] = button_pressed

# national geographic
func _on_national_geographic_toggled(button_pressed):
	Global.user_data['rw']['national_geographic'] = button_pressed

# fun brain
func _on_fun_brain_toggled(button_pressed):
	Global.user_data['rw']['fun_brain'] = button_pressed



# 	sub-window: hidden websites
# browser
func _on_d_browser_toggled(button_pressed):
	Global.user_data['hw']['browser'] = button_pressed

# encyclopedia
func _on_d_encyclopedia_toggled(button_pressed):
	Global.user_data['hw']['encyclopedia'] = button_pressed

# khan academy
func _on_d_khan_academy_toggled(button_pressed):
	Global.user_data['hw']['khan_academy'] = button_pressed

# typing
func _on_d_typing_toggled(button_pressed):
	Global.user_data['hw']['typing'] = button_pressed

# fun educational websites
func _on_few_link_toggled(button_pressed):
	if button_pressed:
		$sub_window/remove_websites/national_geographic/national_geographic.disabled = true
		$sub_window/remove_websites/fun_brain/fun_brain.disabled = true
	else:
		$sub_window/remove_websites/national_geographic/national_geographic.disabled = false
		$sub_window/remove_websites/fun_brain/fun_brain.disabled = false
	$sub_window/remove_websites/national_geographic/national_geographic.pressed = button_pressed
	$sub_window/remove_websites/fun_brain/fun_brain.pressed = button_pressed
	Global.user_data['hw']['fun_educational_websites'] = button_pressed

# national geographic
func _on_d_national_geographic_toggled(button_pressed):
	if button_pressed and $sub_window/remove_websites/fun_brain/fun_brain.pressed:
		$sub_window/remove_websites/few_link/few_link.pressed = true
	Global.user_data['hw']['national_geographic'] = button_pressed

# fun brain
func _on_d_fun_brain_toggled(button_pressed):
	if button_pressed and $sub_window/remove_websites/national_geographic/national_geographic.pressed:
		$sub_window/remove_websites/few_link/few_link.pressed = true
	Global.user_data['hw']['fun_brain'] = button_pressed






# 	sub-window: added websites
# restarts program for changes to take effect
func _on_added_websites_ready():
	$sub_window/add_websites/added_websites.clear()  # preps for refresh
	# the reason this is not in the main _ready() func is because it is called in a below func after an item is edited or added.
	var index: int = 0
	for website in Global.user_data['added']:
		$sub_window/add_websites/added_websites.add_item(website['name'])
		$sub_window/add_websites/added_websites.set_item_tooltip(index, website['url'])
		index += 1
	
	if index == 0:
		$sub_window/add_websites/added_websites/empty_notice.show()
	else:
		$sub_window/add_websites/added_websites/empty_notice.hide()


func get_selected_website():
	if len($sub_window/add_websites/added_websites.get_selected_items()) == 0:
		return
	else:
		return $sub_window/add_websites/added_websites.get_selected_items()[0]

func _on_added_websites_nothing_selected():
	$sub_window/add_websites/added_websites.unselect_all()


func _on_added_websites_item_activated(index):  # if double clicked then edit
	added_websites_operations = 'edit'
	$sub_window/add_websites/add_edit.popup_centered()
	$sub_window/add_websites/add_edit.window_title = 'Edit'
	$sub_window/add_websites/add_edit/name.text = Global.user_data['added'][index]['name']
	$sub_window/add_websites/add_edit/URL.text = Global.user_data['added'][index]['url']
	$sub_window/add_websites/add_edit/restrict_access.pressed = Global.user_data['added'][index]['rw']


var added_websites_operations: String = 'add'
func _on_add_pressed():
	added_websites_operations = 'add'
	$sub_window/add_websites/add_edit.popup_centered()
	$sub_window/add_websites/add_edit.window_title = 'Add'
	$sub_window/add_websites/add_edit/name.text = ''
	$sub_window/add_websites/add_edit/URL.text = ''
	$sub_window/add_websites/add_edit/restrict_access.pressed = false
	
	$sub_window/add_websites/add_edit/name.grab_focus()
	$sub_window/add_websites/added_websites.unselect_all()

func _on_added_websites_add_edit_SAVE_pressed():
	var name: String = $sub_window/add_websites/add_edit/name.text
	var url: String = $sub_window/add_websites/add_edit/URL.text
	var rw: bool = $sub_window/add_websites/add_edit/restrict_access.pressed
	if len(name) < 2 or len(url) < 5:
		$sub_window/add_websites/add_edit.theme.set_color('title_color', 'WindowDialog', Color(1, 0, 0))
		$sub_window/add_websites/add_edit.window_title = 'Please enter a name and valid url'
		yield(get_tree().create_timer(INDICATOR_DISPLAY_TIME), "timeout")  # sleep()
		$sub_window/add_websites/add_edit.theme.set_color('title_color', 'WindowDialog', Color(1, 1, 1))
		$sub_window/add_websites/add_edit.window_title = 'Add'
		# indicator('Please enter a name and valid url', RED_COLOR)
		return
	
	if added_websites_operations == 'add':
		Global.user_data['added'].append({'name': name.capitalize(), 'url': url, 'rw': rw})
	elif added_websites_operations == 'edit':
		var selected_item: int = get_selected_website()
		Global.user_data['added'][selected_item] = {'name': name.capitalize(), 'url': url, 'rw': rw}
	
	$sub_window/add_websites/add_edit.hide()
	_on_added_websites_ready()


func _on_edit_added_websites_pressed():
	var selected_item = get_selected_website()
	if selected_item == null:
		indicator('A website must be selected in order to edit it', RED_COLOR)
		return
	added_websites_operations = 'edit'
	$sub_window/add_websites/add_edit.popup_centered()
	$sub_window/add_websites/add_edit.window_title = 'Edit'
	$sub_window/add_websites/add_edit/name.text = Global.user_data['added'][selected_item]['name']
	$sub_window/add_websites/add_edit/URL.text = Global.user_data['added'][selected_item]['url']
	$sub_window/add_websites/add_edit/restrict_access.pressed = Global.user_data['added'][selected_item]['rw']


func _on_remove_added_website_pressed():
	var selected_item = get_selected_website()
	if selected_item == null:
		indicator('A website must be selected in order to delete it', RED_COLOR)
		return
	Global.user_data['added'].remove(selected_item)
	_on_added_websites_ready()


func _on_added_websites_add_edit_cancel_pressed():
	$sub_window/add_websites/add_edit.hide()


func _on_test_added_website_pressed():
	var selected_item = get_selected_website()
	if selected_item == null:
		indicator('A website must be selected in order to test it', RED_COLOR)
		return
	Website.run_added_website(selected_item, false)


# 	sub-window: transfer data
# restarts program for changes to take effect
var filedialogmode: String = 'null'
func _on_FileDialog_file_selected(path):
	if filedialogmode == 'import':
		var worked = Global.restore_account_from_file(path)
		if worked:
			Global.change_scene('res://scenes/setup/successful_restore.tscn')
		else:
			indicator('The file you selected is corrupted', RED_COLOR)
	elif filedialogmode == 'export':
		Global.export_account_to_file(path)
		indicator('Account has been successfully exported', GREEN_COLOR)

func _on_import_settings_pressed():
	filedialogmode = 'import'
	confirmation_diolog('Importing an account will replace the current account!', 'import')
	
func _on_export_settings_pressed():
	filedialogmode = 'export'
	$FileDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	$FileDialog.current_file = 'acja_web_viewer_account_data'
	$FileDialog.mode = FileDialog.MODE_SAVE_FILE
	$FileDialog.window_title = 'Export Account Data'
	$FileDialog.popup_centered()

func _on_save_pressed():
	confirmation_diolog('This feature will come in future versions of this software.', 'uninstall')



# 	sub-window: reset and uninstall
func _on_reset_pressed():
	confirmation_diolog('Reseting the settings will erase all current settings and reinitiate setup!', 'reset')

func _on_uninstall_pressed():
	'Uninstalling ACJA Website Viewer will completely remove it from this computer!'
	confirmation_diolog('The unistaller feature will come in future versions of this software.', 'uninstall')


# sub-window: about / contact
func _on_contact_page_pressed():
	Global.change_scene('res://scenes/contact.tscn', true)
