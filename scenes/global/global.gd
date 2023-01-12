extends Node  # maybe use SceneTree in autoload scripts later
# sleep(t: float): yield(get_tree().create_timer(<time>), "timeout")

var program_google_account: String = 'gmail-account'  # this is the gmail account that the program uses for contact and OTP emails.
var program_google_account_app_password: String = 'google-app-password'  # App Passwords revoked by google after master password change
var program_id: String = 'd9*38WBBcUIyO$j3T6n@'  # use this for encryption of user data and hash functions (for dev bypass OTP). Note this must be the same as the dev bypass generator program_id for bypass to work.

# lower level functions
var lower_alphabet = 'abcdefghijklmnopqrstuvwxyz'
var upper_alphabet = lower_alphabet.to_upper()
var lower_alphabet_numbers = 'abcdefghijklmnopqrstuvwxyz0123456789'
var upper_alphabet_numbers = lower_alphabet.to_upper() + '0123456789'

func save_to_file(path: String, data: String):
	var file = File.new()
	file.open_encrypted_with_pass(path, File.WRITE, program_id)
	file.store_string(data)
	file.close()


func load_file(path: String):
	var file = File.new()
	file.open_encrypted_with_pass(path, File.READ, program_id)
	var out: String = file.get_as_text()
	file.close()
	return out


func file_exist(path: String):
	return File.new().file_exists(path)


# functions:
func strip(string, strip_chars: String):
	var out: String = ''
	for i in string:
		if not i in strip_chars:
			out += i 
	return out

func exclusive_strip(string, keep_chars: String):
	"""The returned string will only contain chars that are in <keep_chars>"""
	var out: String = ''
	for i in string:
		if i in keep_chars:
			out += i 
	return out

func string_contains(string: String, chars: String):
	for c in string:
		if c in chars:
			return true
	return false

func string_only_contains(string: String, chars: String):
	for c in string:
		if not c in chars:
			return false
	return true


func reset_account_and_settings():  # maybe add parem <only_account> if is true the student data will not be wiped.
	user_data = null_user_data.duplicate(true)
	save_changes()


func is_new_year() -> bool:
	return Time.get_date_dict_from_system()['year'] != Global.user_data['acc']['year']

func renew_year():
	user_data['acc']['year'] += 1
	save_changes()


func save_changes():
	save_to_file(user_data_path, JSON.print(user_data, '	'))


func restore_account_from_file(path: String) -> bool:
	var json_data = JSON.parse(load_file(path)).result
	if json_data != null:  # if file could be parsed into json
		user_data = json_data
		save_changes()
		return true
	else:
		return false


func export_account_to_file(path: String):
	save_to_file(path, JSON.print(user_data, '	'))


var PREVIOUS_SCENES: Array = ['res://scenes/base.tscn']
func get_previous_scene():
	return PREVIOUS_SCENES.pop_back()  # pop_back() returns and removes the last item in an array

func change_scene(path: String, remember_previous_scene: bool = false):
	if remember_previous_scene:
		PREVIOUS_SCENES.append(get_tree().current_scene.filename)  # <current_scene.filename> properties might change in v4.0
	get_tree().change_scene(path)


func is_password(password: String) -> bool:
	return password == user_data['acc']['password']


# vars
var null_user_data: Dictionary = {
	"acc":{
		"name":"",
		"email":"",
		"password":"",
		"question":"",
		"answer":"",
		"exists":false,
		"year":Time.get_date_dict_from_system()['year']  # this is here just as a placeholder. this gets reassigned later in setup.
	},
	"restricted":[],  # name keys are added here. this acts as a blacklist so that a password is required to open them
	"sites":[
			{"name": "browser", "url": "https://kiddle.co/", "icon":'browser', "disabled":false},
			{"name": "encyclopedia", "url": "https://kids.kiddle.co/", "icon":"encyclopedia", "disabled":false},
			{"name": "khan_academy", "url": "https://www.khanacademy.org/", "icon":"khan_academy", "disabled":false},
			{"name": "typing", "url": "https://typing.com", "icon":"typing", "disabled":false},
			{"name": "additional_websites", "url": "--action addtional-websites", "icon":"additional_websites", "disabled":false},
			
			# under added category
			{"name": "national_geographic", "url": "https://kids.nationalgeographic.com/search-results/", "icon":"national_geographic", "disabled":false},
			{"name": "fun_brain", "url": "https://funbrain.com/", "icon":"fun_brain", "disabled":false},
			]  # name: contains name of website, url: contains url or action to be opened/completed, icon: says gives the key to access icon path - it could also be used to check if a website is default, disabled: says wether the default site should not be rendered - disabled key should only be set to true when default key is true
}


var user_data: Dictionary = null_user_data.duplicate(true)
var user_data_path: String = 'user://user_data.save'  # when developing: 'res://user_data.save'
var default_icons: Dictionary = {'generic':'res://ui/icons/buttons/base/generic.png',
								'added':'res://ui/icons/buttons/base/added.png',
								'browser':'res://ui/icons/buttons/base/browser.png',
								'encyclopedia':'res://ui/icons/buttons/base/encyclopedia.png',
								'khan_academy':'res://ui/icons/buttons/base/khan_academy.png',
								'typing':'res://ui/icons/buttons/base/typing.png',
								'additional_websites':'res://ui/icons/buttons/base/additional_websites.png',
								'national_geographic':'res://ui/icons/buttons/base/national_geographic.png',
								'fun_brain':'res://ui/icons/buttons/base/fun_brain.png'}

var last_restricted_website_pressed = {'name': 'settings', 'url': ''}  # can be a button name or an int index of an added website. placeholder is 'settings'


# init
# when update in future make sure to retest this code
func _ready():
	if file_exist(user_data_path):
		var json_data = JSON.parse(load_file(user_data_path)).result
		if json_data != null:  # if file could be parsed into json
			user_data = json_data
		else:
			save_changes()
			_ready()
	else:
		save_changes()
		_ready()
	
	# add data here while programming to change user_data:
	# save_changes()
