# heyImdowndude
A Powershell script, that monitors and pulls the status of url links, when links are down, the script will send you an email letting you the know the url is unresponsive 


#Instructions 
Add Url links to URLList.txt

Edit lines 72 through 82 with your proper email config "Username, password, SMTP Port, TO AND FROM"

When a site is reporting down, it will put the script to sleep for 15 mins before checking again to prevent spam influx.
You can edit this in line 89 "Sleep 900"
