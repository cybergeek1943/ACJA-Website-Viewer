extends Control


var last_restricted_website_pressed = Global.last_restricted_website_pressed


# initializes window
func _ready():
	$password.grab_focus()
	
	if last_restricted_website_pressed['name'] in ['settings', 'google', 'browser', 'encyclopedia', 'khan_academy', 'typing', 'national_geographic', 'fun_brain']:  # list of default icons
		get_node(last_restricted_website_pressed['name'] + "/AnimationPlayer").play("link_icon")
		$link_title.text = 'Permision Required'
	else:
		$added/AnimationPlayer.play("link_icon")
		$link_title.text = last_restricted_website_pressed['name'].replace('_', ' ').capitalize()
	
	
	$link_title/AnimationPlayer.play("link_title")
	$backround/title/AnimationPlayer.play("title")

# buttons
func _on_hide_password_pressed():
	if $password.secret:
		$password.secret = false
	else:
		$password.secret = true

func _on_cancel_pressed():
	Global.change_scene("res://scenes/base.tscn")

func _on_continue_pressed():
	if Global.is_password($password.text):
		if last_restricted_website_pressed['name'] == "settings":
			Global.change_scene("res://scenes/settings.tscn")
		elif last_restricted_website_pressed['name'] == "google":
			Website.open_chrome()
			Global.change_scene("res://scenes/base.tscn")
		else:
			Website.open_url(last_restricted_website_pressed['url'])
			Global.change_scene("res://scenes/base.tscn")
	else:
		$password_incorrect/AnimationPlayer.play("password_incorrect")
		$password.text = ""

func _process(delta):
	if Input.is_action_pressed("ui_enter"):
		_on_continue_pressed()

func _on_forgot_password_pressed():
	Global.change_scene("res://scenes/recovery/recover_password.tscn", true)
