extends Node

var browser_url: String = 'https://kiddle.co/'
var encyclopedia_url: String = 'https://kids.kiddle.co/'
var khan_academy_url: String = 'https://www.khanacademy.org/'
var typing_url: String = 'https://typing.com'
var national_geographic_url: String = 'https://kids.nationalgeographic.com/search-results/'
var fun_brain_url: String = 'https://funbrain.com/'


func open_url(url: String, kiosk: bool = true):
	if kiosk:
		OS.execute('C:/Program Files/Google/Chrome/Application/chrome.exe', ['--kiosk', url], false)
	else:
		OS.execute('C:/Program Files/Google/Chrome/Application/chrome.exe', [url], false)


func run(website_name: String):
	if website_name == 'browser':
		open_url(browser_url)
	elif website_name == 'encyclopedia':
		open_url(encyclopedia_url)
	elif website_name == 'khan_academy':
		open_url(khan_academy_url)
	elif website_name == 'typing':
		open_url(typing_url)
	elif website_name == 'national_geographic':
		open_url(national_geographic_url)
	elif website_name == 'fun_brain':
		open_url(fun_brain_url)

func run_added_website(index: int, kiosk: bool = true):
	open_url(Global.user_data['added'][index]['url'], kiosk)

# chrome for teachers:
func open_chrome():
	OS.shell_open('chrome')
