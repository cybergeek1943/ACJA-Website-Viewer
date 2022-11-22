extends Node  # maybe use SceneTree in autoload scripts later
# sleep(t: float): yield(get_tree().create_timer(<time>), "timeout")

var program_google_account: String = 'asphaleiabrowser@gmail.com'
var program_google_account_app_password: String = 'lfyznwdnvdsxzuxz'  # App Passwords revoked by google after master password change
var program_id: String = 'OL@N6O@$KT67f3JIW5z&'  # use this for encryption of user data and hash functions (for dev bypass OTP). Note this must be the same as the dev bypass generator program_id for bypass to work.


# lower level functions
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
func strip(value, strip_chars: String):
	var out: String = ''
	for i in value:
		if not i in strip_chars:
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
		"year":Time.get_date_dict_from_system()['year']  # this is just here as a placeholder. this gets reassigned later in setup.
	},
	"rw":{
		"browser":false,
		"encyclopedia":false,
		"typing":false,
		"khan_academy":false,
		"national_geographic":false,
		"fun_brain":false
	},
	"hw":{
		"browser":false,
		"encyclopedia":false,
		"typing":false,
		"khan_academy":false,
		"fun_educational_websites":false,
		"national_geographic":false,
		"fun_brain":false
	},
	"added":[]  # format - [{"name": "", "url": "", "rw": false}, {"name": "", "url": "", "rw": false}...]
}

var user_data: Dictionary = null_user_data.duplicate(true)
var user_data_path: String = 'user://user_data.save'  # when developing: 'res://user_data.save'

var last_restricted_button_pressed = "settings"  # can be a button name or an int index of an added website. placeholder is 'settings'


# init
# when update in future make sure to retest this code
func _ready():
	OS.center_window()

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
	# user_data['added'] = [{"name": "youtube", "url": "www.youtube.com", "rw": false}, {"name": "google", "url": "www.google.com", "rw": false}]
	# user_data['acc']['year'] = Time.get_date_dict_from_system()['year'] - 1
	# save_changes()
