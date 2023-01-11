extends Control

# algorithm:
# get page
# set button icons
# arrange button icons

func _ready():
	if not Global.user_data['acc']['exists']:  # checks to see if there is no account
		Global.change_scene('res://scenes/setup/welcome.tscn')
	if Global.is_new_year():  # checks to see if the year has changed... if so initiate new_teacher.tscn
		Global.change_scene("res://scenes/new_year.tscn")




# arrange buttons:
func __arrange(buttons: Array, location: Array):
	var button_count = 0  # to loop through both buttons and location
	for loc in location:
		get_node('page/' + buttons[button_count] + '/button_anim_loc').play(loc)
		button_count += 1

func arrange_buttons(button_count: int):
	# first phase: rearanging prep for each button
	var allowed_buttons: Array = []
	for button in ['0', '1', '2', '3', '4']:
		if not int(button) > button_count - 1:
			allowed_buttons.append(button)
			get_node('page/' + button).show()
		else:
			get_node('page/' + button).hide()
		
	# second phase: rearranging
	if button_count == 5:
		__arrange(allowed_buttons, ['top_left', 'top_right', 'center', 'bottom_left', 'bottom_right'])
	elif button_count == 4:
		__arrange(allowed_buttons, ['top_left', 'top_right', 'bottom_left', 'bottom_right'])
	elif button_count == 3:
		__arrange(allowed_buttons, ['middle_left', 'center', 'middle_right'])
	elif button_count == 2:
		__arrange(allowed_buttons, ['middle_center_left', 'middle_center_right'])
	elif button_count == 1:
		__arrange(allowed_buttons, ['center'])




# button icons
func __set_button_icon(button_path: String, icon_path: String, name: String):
	# icon
	get_node(button_path).icon = load(icon_path)  # loads the image as a resource
	# name
	if name != '':
		get_node(button_path + '/letter').text = name[0]
		get_node(button_path + '/name').text = name.capitalize()
	else:
		get_node(button_path + '/letter').text = ''
		get_node(button_path + '/name').text = ''

func set_button_icons(button_count: int):
	for i in range(button_count):
		if current_page[i]['icon'] != 'added':
			__set_button_icon('page/' + str(i), Global.default_icons[current_page[i]['icon']], '')
		else:
			__set_button_icon('page/' + str(i), Global.default_icons['added'], current_page[i]['name'])




# page
var current_page = []  # contains the sites that will be displayed
var __page_range = [0, 4]

func __remove_disabled_defaults():
	for site in current_page.duplicate():
		if site['disabled']:
			current_page.erase(site)

func __refresh_page():  # called when page is _ready()
	current_page = Global.user_data['sites'].slice(__page_range[0], __page_range[1])
	__remove_disabled_defaults()
	set_button_icons(len(current_page))
	arrange_buttons(len(current_page))
	
	if len(current_page) == 0:
		$page/no_websites.show()
	else:
		$page/no_websites.hide()
		

func go_right():
	__page_range[0] += 5
	__page_range[1] += 5
	
	$page/AnimationPlayer.play("change_page_p1")
	yield(get_tree().create_timer(0.33), "timeout")
	__refresh_page()
	$page/AnimationPlayer.play("change_page_p2")

func go_left():
	__page_range[1] -= 5
	__page_range[0] -= 5
	
	$page/AnimationPlayer.play_backwards("change_page_p2")
	yield(get_tree().create_timer(0.33), "timeout")
	__refresh_page()
	$page/AnimationPlayer.play_backwards("change_page_p1")




# page change buttons
func manage_page_change_buttons():
	# when to show button/s - first page
	if __current_page_num == 1 and __total_page_num == 1:
		$left_page/show.play("show")
	if __current_page_num == 1 and __previous_page_num == 0 and __total_page_num != 1:
		$left_page/show.play("show")
		$right_page/show.play("show")
	
	# when to hide/show right button - last page
	if __current_page_num == __total_page_num and __total_page_num != 1:
		$right_page/show.play_backwards("show")
	if __current_page_num == __total_page_num - 1 and __previous_page_num == __total_page_num and __total_page_num != 1:
		$right_page/show.play("show")
	
	# when at home page
	if __current_page_num == 0 and __total_page_num != 1:
		$left_page/show.play_backwards("show")
		$right_page/show.play_backwards("show")
	if __current_page_num == 0 and __total_page_num == 1:
		$left_page/show.play_backwards("show")
	
	# when to show QuickView button
	if __current_page_num == 0:
		$open_quick_view/AnimationPlayer.play_backwards("show")
	elif __current_page_num == 1 and __previous_page_num == 0:
		$open_quick_view/AnimationPlayer.play("show")


var __total_page_num = ceil(float(len(Global.user_data['sites']))/5) - 1
var __current_page_num = 0
var __previous_page_num = 0
var __buttons_activated: bool = true  # TODO work on ativating the buttons
func _on_right_page_pressed():
	if not __buttons_activated:
		return
	__buttons_activated = false
	
	__current_page_num += 1
	__previous_page_num = __current_page_num - 1
	manage_page_change_buttons()
	
	go_right()
	
	yield(get_tree().create_timer(0.66), "timeout")
	__buttons_activated = true

func _on_left_page_pressed():
	if not __buttons_activated:
		return
	__buttons_activated = false
	
	__current_page_num -= 1
	__previous_page_num = __current_page_num + 1
	manage_page_change_buttons()
	
	go_left()
	
	yield(get_tree().create_timer(0.66), "timeout")
	__buttons_activated = true




# QuickView --- the button show/hide is in the above section
func _on_open_quick_view_pressed():
	__quick_view_is_open = true
	_on_quick_view_opened()  # load websites
	$quick_view/search.grab_focus()
	$quick_view/AnimationPlayer.play("show")

func _on_close_quick_view_pressed():
	__quick_view_is_open = false
	$quick_view/search.text = ''
	$quick_view/search.release_focus()
	$quick_view/AnimationPlayer.play_backwards("show")

func __set_items_visuals():
	$quick_view.icon_scale = 0.5
	for i in range($quick_view.get_item_count()):
		$quick_view.set_item_tooltip_enabled(i, false)
		
		var added_swap_with_generic: Dictionary = {'added': 'generic'}
		var icon: String = $quick_view.get_item_metadata(i)['icon']
		$quick_view.set_item_icon(i, load(Global.default_icons[added_swap_with_generic.get(icon, icon)]))

func __get_search_text():
	return Global.exclusive_strip($quick_view/search.text.to_lower(), Global.lower_alphabet_numbers)

var __quick_view_is_open: bool = false
var __previous_search: String = 'nothing'
func _on_quick_view_opened():  # called when QuickView is opened
	if __quick_view_is_open:
		if __get_search_text() != __previous_search:
			$quick_view.clear() # to prepare for next refresh
			
			var websites = Global.user_data['sites']
			for website in websites.slice(0, 3) + websites.slice(5, -1):  # we do the slices so that "Additional Websites" button is not included in the list
				if not website['disabled']:
					if __get_search_text() == '':
						$quick_view.add_item('  ' + website['name'].capitalize())
						$quick_view.set_item_metadata($quick_view.get_item_count() - 1, website)
					elif Global.exclusive_strip(website['name'].to_lower(), Global.lower_alphabet_numbers).begins_with(__get_search_text()):
						$quick_view.add_item('  ' + website['name'].capitalize())
						$quick_view.set_item_metadata($quick_view.get_item_count() - 1, website)
			
			if $quick_view.get_item_count() == 0:
				$quick_view/nothing_found.show()
			else:
				$quick_view/nothing_found.hide()
			
			__set_items_visuals()
		
		__previous_search = __get_search_text()
		yield(get_tree().create_timer(0.5), "timeout")
		_on_quick_view_opened()

func _on_quick_view_nothing_selected():
	$quick_view.unselect_all()

func _on_quick_view_item_activated(index):
	var website: Dictionary = $quick_view.get_item_metadata(index)
	if not website['name'] in Global.user_data['restricted']:
		Website.open_url(website['url'])
	else:
		Global.last_restricted_website_pressed['name'] = website['name']
		Global.last_restricted_website_pressed['url'] = website['url']
		Global.change_scene('res://scenes/password_wall.tscn')
	
	$quick_view.unselect_all()
	$quick_view/search.clear()
	_on_close_quick_view_pressed()




# main buttons
func button_pressed(index):  # arg can be button index or name
	# check for custom actions
	if current_page[index]['url'] == '--action addtional-websites':  # "--action addtional-websites" is an arbitrary custom action made for turning the page right
		_on_right_page_pressed()  # this function to be done so that page buttons work properly
	
	# run websites as usual
	elif not current_page[index]['name'] in Global.user_data['restricted']:
		Website.open_url(current_page[index]['url'])
	else:
		Global.last_restricted_website_pressed['name'] = current_page[index]['name']
		Global.last_restricted_website_pressed['url'] = current_page[index]['url']
		Global.change_scene('res://scenes/password_wall.tscn')




# admin buttons
func _on_google_pressed():
	Global.last_restricted_website_pressed['name'] = 'google'
	Global.change_scene('res://scenes/password_wall.tscn')

func _on_settings_pressed():
	Global.last_restricted_website_pressed['name'] = 'settings'
	Global.change_scene('res://scenes/password_wall.tscn')




# main button animations
func _on_mouse_entered():
	$button_anim_loc.play('button_animation')

func _on_mouse_exited():
	$button_anim_loc.play_backwards('button_animation')

# page change button animations
func _on_page_buttons_mouse_entered():
	$hover.play('hover')

func _on_page_buttons_mouse_exited():
	$hover.play_backwards("hover")
