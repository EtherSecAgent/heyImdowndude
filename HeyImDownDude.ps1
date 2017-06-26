
Function it 
    {
    Write-Host "Grabbing and checking services"
    Sleep 3 

    ## The URI list to test
    $URLListFile = ".\URLList.txt" 
    $URLList = Get-Content $URLListFile -ErrorAction SilentlyContinue
    $Result = @()
  
  
Foreach ($Uri in $URLList) 
    {
    $time = try{
    $request = $null
    ## Request the URI, and measure how long the response took.
    $result1 = Measure-Command { $request = Invoke-WebRequest -Uri $uri }
    $result1.TotalMilliseconds
    } 
catch
    {
    $request = $_.Exception.Response
    $time = -1
    }  
    $result += [PSCustomObject] @{
    Time = Get-Date;
    Uri = $uri;
    StatusCode = [int] $request.StatusCode;
    StatusDescription = $request.StatusDescription;
    ResponseLength = $request.RawContentLength;
    TimeTaken =  $time; 
    }

    }


    
if
    ($result -ne $null)
    {
    Foreach($Entry in $Result)
    {
    if($Entry.StatusCode -ne "200")
    {
    Write-Host -Foregroundcolor red "Error $Entry"
    (echo "Error $Entry" | Add-Content .\Down.txt | Set-Content .\Down.txt)
    (echo "Error $Entry" | Add-Content .\Events.txt | Set-Content .\Events.txt)
    }
    
else
    {
    Write-Host -Foregroundcolor green "$Entry"
    Sleep 10
    }
       
    }

mail
    }



Function mail 
    {
    $Report = Get-Content .\Down.txt
    
if  ($report -match "http")
    {
    Write-Host -ForegroundColor cyan "Check Complete, preparing email"
    Sleep 5 
    $EmailFrom = "YOUREMAIL" 
    $EmailTo = "WHEREYOURSENDINGEMAIL" 
    $SMTPServer = "smtp.gmail.com" 
    $EmailSubject = "Services Monitoring Result"  
 
    #Send mail with output 
    $mailmessage = New-Object system.net.mail.mailmessage  
    $mailmessage.from = ($EmailFrom)  
    $mailmessage.To.add($EmailTo) 
    $mailmessage.Subject = $EmailSubject 
    $mailmessage.Body = (Get-Content .\Down.txt | Select-String "http")
    $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer,587)   
    $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("YOUREMAIL", "YOUREMAILPASSWORD");  
    $SMTPClient.EnableSsl = $true  
    $SMTPClient.Send($mailmessage)
    sleep 5
    Write-Host -ForegroundColor Cyan "Cleaning up Down.txt, Spam Prevention at 900secs"
    sleep 900
    }
    

if  ($report -notmatch "http")
    {
    Write-Host -ForegroundColor Cyan "All okay, going to sleep"
    Sleep 60
    }
    }
    Clear-Content .\Down.txt
    cls
    loop
    }
Function loop
    {
    Write-Host -ForegroundColor darkcyan "Just swinging around"
    Start-Sleep 15
    sleep 10
    cls
    it 
    }
    it


    
