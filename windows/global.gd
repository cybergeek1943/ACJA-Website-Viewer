extends Node  # maybe use SceneTree in autoload scripts later


# lower level functions
func save_to_file(path: String, data: String):
	var file = File.new()
	file.open_encrypted_with_pass(path, File.WRITE, 'OL@N6O@$KT67f3JIW5z&')
	file.store_string(data)
	file.close()


func load_file(path: String):
	var file = File.new()
	file.open_encrypted_with_pass(path, File.READ, 'OL@N6O@$KT67f3JIW5z&')
	var out: String = file.get_as_text()
	file.close()
	return out


func file_exist(path: String):
	return File.new().file_exists(path)


# functions
func strip(value, strip_chars: String):
	var out: String = ''
	for i in value:
		if not i in strip_chars:
			out += i 
	return out


func reset_account_and_settings():
	user_data = null_user_data
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

# vars
var null_user_data: Dictionary = {
	"acc":{
		"name":"",
		"email":"",
		"password":"",
		"question":"",
		"answer":"",
		"exists":false
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

var user_data: Dictionary = null_user_data
var user_data_path: String = 'user://user_data.save'  # when developing: 'res://user_data.save'

var last_restricted_button_pressed = ""  # can be a button name or an int index of an added website


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
