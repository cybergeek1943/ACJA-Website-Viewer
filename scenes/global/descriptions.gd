extends Node
# this is a global file containing all the descriptions for the settings page.

# settings pages
var acc: String = """This local account is used to access this software's Settings, Restricted Websites - (If enabled), and Google Chrome.

Password Recovery: Is used for recovering the password if it gets lost or forgotten."""


var rw: String = """Restricting a website makes it so that the password is required to open it. It does not entirely remove a website but only requires administrator permission to open it.


To completely remove websites from the home page go to (Remove Websites)."""


var hw: String = """Removing\\Disabling websites completely removes them from the home page.


To only restrict access to websites by requiring a password go to (Restrict Websites)."""


var aw: String = """Gives the ability to add additional websites which can be used by the student. The button to open the additional websites is at the bottom-right of the home page."""


var ta: String = """Transfering the account saves administrator information and settings data to a file that can then be transferred to another computer and imported there.

Saving an installer for this software will give you an installer that can be used on another computer."""


var ru: String = """Resetting this software will completely remove all administrator information and settings.

Uninstalling this software will completely remove Asphaleia Browser and Google Chrome from this computer.


Before executing one of these operations consider going to (Transfer Account) to save this account and settings to a file."""


# account recovery:
var otp: String = """A 6-digit security code has been sent to your email inbox at (%s). If you did not receive it, please press the resend button, check your spam folder, or check your internet connection."""

var option_2: String = """If you were unable to answer the recovery question or could not get the security code, you may contact the developer of this software using (cybergeek.1943@gmail.com) to get a developers bypass code."""  # not loaded
