whoami /all
netstat -ano
netsh firewall show config
wmic service get pathname,displayname,name,startmode | findstr /i "Auto" |findstr /i /v "C:\Windows\\" | findstr /i /v """
