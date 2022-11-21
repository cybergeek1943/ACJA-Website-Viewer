extends Node

var connection_status: bool = false

func check():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, '_on_request_completed')
	http_request.request('http://example.com/')

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		connection_status = true
	else:
		connection_status = false
