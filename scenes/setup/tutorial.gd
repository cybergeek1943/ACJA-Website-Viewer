extends Control

var playing: bool = false
func _on_animation_started(anim_name):
	playing = true

var page: int = 1
func _on_animation_finished(anim_name):
	if anim_name != 'welcome_label':
		page += 1
	playing = false

func _on_next_pressed():
	if not playing:
		if page == 1:
			$AnimationPlayer.play("admin_outline")
		elif page == 2:
			$AnimationPlayer.play("3rd_page")
			$next.text = 'Done'
		elif page == 3:
			Global.change_scene('res://scenes/base.tscn')

func _on_back_pressed():
	if not playing:
		if page == 2:
			$AnimationPlayer.play_backwards("admin_outline")
		elif page == 3:
			$AnimationPlayer.play_backwards("3rd_page")
			$next.text = 'Next'
		page -= 2  # we have to subtract 2 because play_backwards() will add 1 undoing our subraction
