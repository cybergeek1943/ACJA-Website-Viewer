extends Control


var password: String = Global.user_data['acc']['password']
var last_restricted_button_pressed = Global.last_restricted_button_pressed


# initializes window
func _ready():
	$password.grab_focus()
	
	if typeof(last_restricted_button_pressed) == TYPE_STRING:
		if last_restricted_button_pressed == 'google':
			$link_title.text = 'Google Chrome'
		elif last_restricted_button_pressed == 'settings':
			$link_title.text = 'Settings'
		else:
			$link_title.text = 'Permision Required'
		get_node(last_restricted_button_pressed + '/AnimationPlayer').play('link_icon')
		$link_title/AnimationPlayer.play('link_title')
	
	elif typeof(last_restricted_button_pressed) == TYPE_INT:  # if index for added website
		$link_title.text = Global.user_data['added'][last_restricted_button_pressed]['name']
		$logo/AnimationPlayer.play("link_icon")
	
	$link_title/AnimationPlayer.play('link_title')
	$acja_website_viewer/AnimationPlayer.play('acja_website_viewer')

# buttons
func _on_cancel_pressed():
	get_tree().change_scene('res://windows/base.tscn')

func _on_continue_pressed():
	if $password.text == password:
		if typeof(last_restricted_button_pressed) == TYPE_STRING:
			if last_restricted_button_pressed == 'settings':
				get_tree().change_scene('res://windows/settings.tscn')
			elif last_restricted_button_pressed == 'google':
				Website.open_chrome()
				get_tree().change_scene('res://windows/base.tscn')
			else:
				Website.run(last_restricted_button_pressed)
				get_tree().change_scene('res://windows/base.tscn')
		elif typeof(last_restricted_button_pressed) == TYPE_INT:
			Website.run_added_website(last_restricted_button_pressed)
			get_tree().change_scene('res://windows/base.tscn')
	else:
		$password_incorrect/AnimationPlayer.play('password_incorrect')
		$password.text = ''

func _process(delta):
	if Input.is_action_pressed('ui_enter'):
		_on_continue_pressed()

func _on_recover_password_pressed():
	get_tree().change_scene('res://windows/recover_password.tscn')
