extends Node

# lower level function:
# send_email() needs to give some feedback if it if was sent successfully.... this is critical for the contact page to work
const SEND_ENABLED: bool = true  # for testing purposes - when true: send. when false: print
func send_email(subject: String, body: String, emailto: String = Global.user_data["acc"]["email"]):
	# senders account and authentication:
	var google_account: String = Global.program_google_account
	var google_app_password: String = Global.program_google_account_app_password
	
	# command for the power shell to use. it uses the .net framwork.
	var command_body = [
		"$EmailFrom = '%s'"%[google_account],
		"$EmailTo = '%s'"%[emailto],
		"$Subject = '%s'"%[subject],
		"$Body = '%s'"%[body],
		"$SMTPServer = 'smtp.gmail.com'",
		"$SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, 587)",
		"$SMTPClient.EnableSsl = $true",
		"$SMTPClient.Credentials = New-Object System.Net.NetworkCredential('%s', '%s')"%[google_account, google_app_password],
		"$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)",
	]
	
	# put all the commands into one string seperated by ";" semicolons:
	var commands = ""
	var count = 1
	for command in len(command_body):  # compile powershell commands:
		if count != len(command_body):
			commands += command_body[command] + "; "
		else:
			commands += command_body[command]
		
		count += 1
	
	# execute commands and get output-(which is not being used in this function):
	if SEND_ENABLED:
		var result_code = OS.execute("C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe", [commands], false)  # result_code will not have a result code when blocking (the last parameter) is set to false
		return result_code
	else:
		print(body)  # for testing purposes only


# email otp
var otp: String = otp_gen()

func otp_gen(length: int = 6) -> String:  # generates random pin that is used to unlock password
	randomize()  # reseeds
	var out: String = ""
	for _i in range(length):
		out += str(randi() % 10)  # modulo 10 to get 6 digit pin
	# print(out)  # for testing only
	return out

func send_recovery_email(_otp: String = otp):
	var subject: String = "Asphaleia Browser Verification Code: %s"%_otp
	var body: String = """Use this code to recover your account:
		
%s
		
If you do not recogize this request you can safely ignore this email."""%_otp
	send_email(subject, body)

func send_confirmation_email(_otp: String = otp):
	var subject: String = "Asphaleia Browser Verification Code: %s"%_otp
	var body: String = """Use this code to confirm your email address:
		
%s
		
If you do not recogize this request you can safely ignore this email."""%_otp
	send_email(subject, body)

func refresh_otp():
	otp = otp_gen()
