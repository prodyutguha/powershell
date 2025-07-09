$user = Import-Csv 'C:\Users\ism\Desktop\mail.csv'
#$user

foreach($userid in $user)
{

$u = $userid.Email_ID
$p = $userid.Password

Write-Host " Sending Mail to $u"

       $outputreport = "<HTML>
   <BODY>

   <p>Hello $u</p>

   <p>This is an automated mail for New O365 UserID & Password. Please find the below details</p>
   <br>

   Email ID : $u<br>
   Password : $p
   <br>
   <br>

   Thanks & Regards<br>
   Microsoft Online Cloud Team

   </BODY>
   </HTML>"

   $username = "migration1@iitism.ac.in"
   $password = ""

   $smtpServer = "smtp.gmail.com"
   $port = "587"

   $pass = ConvertTo-SecureString -String $password -AsPlainText -Force
   $cred = New-Object System.Management.Automation.PSCredential $username, $pass

   $sub = "$u was added successfully"

   $EmailFrom = "migration1@iitism.ac.in"

   $EmailTo = $u

Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $sub -Body $outputreport -BodyAsHtml -SmtpServer $smtpServer -Port $port -Credential $cred -UseSsl
}