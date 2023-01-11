extends Node

func open_url(url: String, kiosk: bool = true):
	if kiosk:
		OS.execute('C:/Program Files/Google/Chrome/Application/chrome.exe', ['--kiosk', url], false)
	else:
		OS.execute('C:/Program Files/Google/Chrome/Application/chrome.exe', [url], false)

# chrome for admin:
func open_chrome():
	OS.shell_open('chrome')
