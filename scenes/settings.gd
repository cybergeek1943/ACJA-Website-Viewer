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


func notice_diolog(message: String, wait: float = 0):
	if wait != 0:
		yield(get_tree().create_timer(wait), "timeout")
	$NoticeDialog.dialog_text = message
	$NoticeDialog.popup_centered()
	



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

# exits program
func _on_exit_pressed():
	confirmation_diolog('Are you sure you want to exit?', 'exit')

# goes back to base window
func _on_back_to_base_pressed():
	confirmation_diolog('Are you sure you want to back to the home page?', 'back')


# menu buttons
func _emulate_focus_button(index: int): # called when the side bar is ready --- TODO make this so that a real <focus> is used on its own layer when 4.0 comes out!
	var buttons: Array = ['account_information', 'restrict_sites', 'remove_sites', 'add_sites', 'transfer_account',  'reset_uninstall', 'about']
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

func _on_restrict_sites_pressed():
	_emulate_focus_button(1)
	$menu_buttons/button_indicator/AnimationPlayer.play('restrict_websites')
	$sub_window/AnimationPlayer.play('restrict_websites')
	
	# custom
	indicator('Select or double click on a website to restrict it', GREEN_COLOR, 3)

func _on_remove_sites_pressed():
	_emulate_focus_button(2)
	$menu_buttons/button_indicator/AnimationPlayer.play('remove_websites')
	$sub_window/AnimationPlayer.play('remove_websites')
	
	# custom
	indicator('Select a website to remove\\disable it', GREEN_COLOR, 3)

func _on_add_sites_pressed():
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



# sub-window: account_information
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




# load all ItemLists websites for Restrict Websites, Remove Websites, Add Websites
func reload_all_lists_websites():
	_on_restricted_websites_ready()
	_on_remove_websites_ready()
	_on_added_websites_ready()




# 	sub-window: restricted websites
func _on_restricted_websites_ready():  # load websites
	$sub_window/restrict_websites/sites.clear()
	var index: int = 0
	var websites: Array = Global.user_data['sites']
	for site in websites.slice(0, 3) + websites.slice(5, -1):
		var site_is_restricted: bool = site['name'] in Global.user_data['restricted']
		
		if site_is_restricted:
			$sub_window/restrict_websites/sites.add_item(site['name'].capitalize() + '  -  Restricted')
			$sub_window/restrict_websites/sites.set_item_icon(index, load('res://ui/icons/buttons/settings/websites/lock_large.png'))
		else:
			$sub_window/restrict_websites/sites.add_item(site['name'].capitalize())
			$sub_window/restrict_websites/sites.set_item_icon(index, load(Global.default_icons[{'added': 'generic'}.get(site['icon'], site['icon'])]))
		
		var meta_data = site.duplicate()
		meta_data.merge({'restricted': site_is_restricted})
		$sub_window/restrict_websites/sites.set_item_metadata(index, meta_data)  # true for restricted
		
		$sub_window/restrict_websites/sites.set_item_tooltip(index, site['url'])
		index += 1

func __set_button_to_restrict_or_allow(restricted: bool = true):
	if restricted:  # if restricted
		$sub_window/restrict_websites/restrict_allow.text = ' Unlock'
		$sub_window/restrict_websites/restrict_allow.icon = load('res://ui/icons/buttons/settings/websites/unlock.png')
	else:
		$sub_window/restrict_websites/restrict_allow.text = ' Restrict'
		$sub_window/restrict_websites/restrict_allow.icon = load('res://ui/icons/buttons/settings/websites/lock.png')

var __restricted_websites_selected_item: int = -1  # -1 means nothing selected
func _on_restricted_websites_item_selected(index: int):
	__restricted_websites_selected_item = index
	__set_button_to_restrict_or_allow($sub_window/restrict_websites/sites.get_item_metadata(index)['restricted'])

func _on_restricted_websites_item_activated(index: int):
	if index != -1:
		var selected_item_meta_data: Dictionary = $sub_window/restrict_websites/sites.get_item_metadata(index)
		if selected_item_meta_data['restricted']:
			Global.user_data['restricted'].erase(selected_item_meta_data['name'])
			$sub_window/restrict_websites/sites.set_item_text(index, selected_item_meta_data['name'].capitalize())
			$sub_window/restrict_websites/sites.set_item_icon(index, load(Global.default_icons[{'added': 'generic'}.get(selected_item_meta_data['icon'], selected_item_meta_data['icon'])]))
			selected_item_meta_data['restricted'] = false
			__set_button_to_restrict_or_allow(false)
		else:
			Global.user_data['restricted'].append(selected_item_meta_data['name'])
			$sub_window/restrict_websites/sites.set_item_text(index, selected_item_meta_data['name'].capitalize() + '  -  Restricted')
			$sub_window/restrict_websites/sites.set_item_icon(index, load('res://ui/icons/buttons/settings/websites/lock_large.png'))
			selected_item_meta_data['restricted'] = true
			__set_button_to_restrict_or_allow(true)
	else:
		indicator('Select or double click on a website to restrict it', GREEN_COLOR, 3)

func _on_restrict_or_allow_pressed():
	_on_restricted_websites_item_activated(__restricted_websites_selected_item)




# 	sub-window: remove websites
func _on_remove_websites_ready():  # load websites
	$sub_window/remove_websites/sites.clear()
	var index: int = 0
	for site in Global.user_data['sites']:
		if site['disabled']: # if site is default and disabled
			$sub_window/remove_websites/sites.add_item(site['name'].capitalize() + '  -  Disabled')
			$sub_window/remove_websites/sites.set_item_icon(index, load('res://ui/icons/buttons/settings/websites/lock_large.png'))
		else:
			$sub_window/remove_websites/sites.add_item(site['name'].capitalize())
			$sub_window/remove_websites/sites.set_item_icon(index, load(Global.default_icons[{'added': 'generic'}.get(site['icon'], site['icon'])]))
		
		$sub_window/remove_websites/sites.set_item_tooltip(index, site['url'])
		$sub_window/remove_websites/sites.set_item_metadata(index, site)
		index += 1

var __last_showed_both_buttons: bool = false
func __show_both_remove_and_disable_enable(show: bool):  # if true show both, else show one
	if show and not __last_showed_both_buttons:
		$sub_window/remove_websites/show_disable_enable.play("show")
		__last_showed_both_buttons = true
	elif not show and __last_showed_both_buttons:
		$sub_window/remove_websites/show_disable_enable.play_backwards("show")
		__last_showed_both_buttons = false

var __last_swaped_to_disable_enable: bool = false
func __swap_remove_to_disable_enable(swap: bool):  # if true swap to disable\enable, if false swap to remove
	if swap and not __last_swaped_to_disable_enable:
		$sub_window/remove_websites.move_child($sub_window/remove_websites/remove, $sub_window/remove_websites/remove.get_position_in_parent()-1)
		__last_swaped_to_disable_enable = true
	elif not swap and __last_swaped_to_disable_enable:
		$sub_window/remove_websites.move_child($sub_window/remove_websites/remove, $sub_window/remove_websites/remove.get_position_in_parent()+1)
		__last_swaped_to_disable_enable = false

var __last_button_set_is_enabled: bool = false
func __set_disable_button_to_enable(enable: bool): # if enable is true set to enable, otherwise set to disable
	if enable and not __last_button_set_is_enabled:
		$sub_window/remove_websites/disable_enable.text = ' Enable'
		$sub_window/remove_websites/disable_enable.icon = load('res://ui/icons/buttons/settings/websites/unlock.png')
		__last_button_set_is_enabled = true
	elif not enable and __last_button_set_is_enabled:
		$sub_window/remove_websites/disable_enable.text = ' Disable'
		$sub_window/remove_websites/disable_enable.icon = load('res://ui/icons/buttons/settings/websites/lock.png')
		__last_button_set_is_enabled = false

var __remove_website_selected_item: int = -1  # -1 means nothing selected
func _on_remove_website_item_selected(index: int):
	__remove_website_selected_item = index
	var site: Dictionary = $sub_window/remove_websites/sites.get_item_metadata(index)
	
	if site['icon'] != 'added' and not site['disabled']: # if site is default and not disabled
		__swap_remove_to_disable_enable(true)
		__show_both_remove_and_disable_enable(false)
		__set_disable_button_to_enable(false)
	elif site['icon'] != 'added' and site['disabled']: # if site is default and is disabled
		__swap_remove_to_disable_enable(true)
		__show_both_remove_and_disable_enable(false)
		__set_disable_button_to_enable(true)
	
	elif site['icon'] == 'added' and not site['disabled']: # if site is not default and site is not disabled
		__show_both_remove_and_disable_enable(true)
		__set_disable_button_to_enable(false)
	elif site['icon'] == 'added' and site['disabled']: # if site is not default and site is disabled
		__show_both_remove_and_disable_enable(true)
		__set_disable_button_to_enable(true)


func __determine_additional_websites():  # NOT IN USE --- this function disables "Additional Websites" if all the additional websites have been removed/disabled
	if __remove_website_selected_item >= 4:
		var additional_websites_site: Dictionary = Global.user_data['sites'][4]
		var additional_websites: Array = Global.user_data['sites'].slice(5, -1)
		
		for site in additional_websites.duplicate():  # this is to consider disabled sites as though they had been removed
			if site['disabled']:
				additional_websites.erase(site)
		
		if not additional_websites_site['disabled'] and len(additional_websites) == 0:
			additional_websites_site['disabled'] = true
			$sub_window/remove_websites/sites.set_item_text(4, additional_websites_site['name'].capitalize() + '  -  Disabled')
			$sub_window/remove_websites/sites.set_item_icon(4, load('res://ui/icons/buttons/settings/websites/lock_large.png'))
			
			__set_disable_button_to_enable(true)
			notice_diolog("Since all additional websites have been removed\\disabled the additional websites option has been disabled.\nTo re-enable the additional websites option you must add\\re-enable any addidtional website.", 0.5)

func _on_remove_pressed():
	if __remove_website_selected_item != -1:  # if something is selected
		var site: Dictionary = $sub_window/remove_websites/sites.get_item_metadata(__remove_website_selected_item)
		Global.user_data['sites'].erase(site)
		reload_all_lists_websites()
		
		__swap_remove_to_disable_enable(false)
		__show_both_remove_and_disable_enable(false)
		__remove_website_selected_item = -1
	else:
		indicator('Select a website to remove\\disable it', GREEN_COLOR, 3)

func _on_disable_enable_pressed():
	var site: Dictionary = $sub_window/remove_websites/sites.get_item_metadata(__remove_website_selected_item)
	if not site['disabled']: # if site is default and not disabled
		site['disabled'] = true
		$sub_window/remove_websites/sites.set_item_text(__remove_website_selected_item, site['name'].capitalize() + '  -  Disabled')
		$sub_window/remove_websites/sites.set_item_icon(__remove_website_selected_item, load('res://ui/icons/buttons/settings/websites/lock_large.png'))
		__set_disable_button_to_enable(true)
	elif site['disabled']: # if site is default and is disabled
		site['disabled'] = false
		$sub_window/remove_websites/sites.set_item_text(__remove_website_selected_item, site['name'].capitalize())
		$sub_window/remove_websites/sites.set_item_icon(__remove_website_selected_item, load(Global.default_icons[{'added': 'generic'}.get(site['icon'], site['icon'])]))
		__set_disable_button_to_enable(false)




# 	sub-window: added websites
# restarts program for changes to take effect
func _on_added_websites_ready():
	$sub_window/add_websites/sites.clear()
	var index: int = 0
	for site in Global.user_data['sites'].slice(7, -1):
		$sub_window/add_websites/sites.add_item(site['name'].capitalize())
		$sub_window/add_websites/sites.set_item_icon(index, load(Global.default_icons['generic']))
		
		$sub_window/add_websites/sites.set_item_tooltip(index, site['url'])
		$sub_window/add_websites/sites.set_item_metadata(index, site)
		index += 1
	
	if index == 0:
		$sub_window/add_websites/sites/empty_notice.show()
	else:
		$sub_window/add_websites/sites/empty_notice.hide()


func _on_added_websites_nothing_selected():
	$sub_window/add_websites/sites.unselect_all()

func get_added_selected_website():
	if len($sub_window/add_websites/sites.get_selected_items()) == 0:
		return
	else:
		return $sub_window/add_websites/sites.get_selected_items()[0]

func _on_added_websites_add_edit_SAVE_pressed():
	var name: String = $sub_window/add_websites/add_edit/name.text
	var url: String = $sub_window/add_websites/add_edit/URL.text
	var restricted: bool = $sub_window/add_websites/add_edit/restrict_access.pressed
	if len(name) < 2 or len(url) < 5:
		$sub_window/add_websites/add_edit.theme.set_color('title_color', 'WindowDialog', Color(1, 0, 0))
		$sub_window/add_websites/add_edit.window_title = 'Please enter a name and valid url'
		yield(get_tree().create_timer(INDICATOR_DISPLAY_TIME), "timeout")  # sleep()
		$sub_window/add_websites/add_edit.theme.set_color('title_color', 'WindowDialog', Color(1, 1, 1))
		$sub_window/add_websites/add_edit.window_title = 'Add'
		# indicator('Please enter a name and valid url', RED_COLOR)
		return
	
	if added_websites_operations == 'add':
		Global.user_data['sites'].append({"name": name, "url": url, "icon":"added", "disabled":false})
		if restricted:
			Global.user_data['restricted'].append(name)
	elif added_websites_operations == 'edit':
		var site: Dictionary = $sub_window/add_websites/sites.get_item_metadata(get_added_selected_website())
		site['name'] = name
		site['url'] = url
		if restricted:
			Global.user_data['restricted'].append(name)
		else:
			Global.user_data['restricted'].erase(name)
	
	$sub_window/add_websites/add_edit.hide()
	reload_all_lists_websites()

var added_websites_operations: String = 'add'
func _on_add_pressed():
	added_websites_operations = 'add'
	$sub_window/add_websites/add_edit.popup_centered()
	$sub_window/add_websites/add_edit.window_title = 'Add'
	$sub_window/add_websites/add_edit/name.text = ''
	$sub_window/add_websites/add_edit/URL.text = ''
	$sub_window/add_websites/add_edit/restrict_access.pressed = false
	
	$sub_window/add_websites/add_edit/name.grab_focus()
	$sub_window/add_websites/sites.unselect_all()

func _on_edit_added_websites_pressed():
	var index = get_added_selected_website()
	if index == null:
		indicator('Selected a website to edit it', GREEN_COLOR)
		return
	added_websites_operations = 'edit'
	_on_added_websites_item_activated(index)

func _on_added_websites_item_activated(index):  # if double clicked then edit
	var site: Dictionary = $sub_window/add_websites/sites.get_item_metadata(index)
	added_websites_operations = 'edit'
	$sub_window/add_websites/add_edit.popup_centered()
	$sub_window/add_websites/add_edit.window_title = 'Edit'
	$sub_window/add_websites/add_edit/name.text = site['name']
	$sub_window/add_websites/add_edit/URL.text = site['url']
	$sub_window/add_websites/add_edit/restrict_access.pressed = site['name'] in Global.user_data['restricted']

func _on_remove_added_website_pressed():
	var index = get_added_selected_website()
	if index == null:
		indicator('Selected a website to remove it', GREEN_COLOR)
		return
	Global.user_data['sites'].erase($sub_window/add_websites/sites.get_item_metadata(index))
	reload_all_lists_websites()


func _on_added_websites_add_edit_cancel_pressed():
	$sub_window/add_websites/add_edit.hide()


func _on_test_added_website_pressed():
	var index = get_added_selected_website()
	if index == null:
		indicator('Selected a website to test it', GREEN_COLOR)
		return
	Website.open_url($sub_window/add_websites/sites.get_item_metadata(index)['url'], false)




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
