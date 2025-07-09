#Check for EXO v3 module installation
$Module = (Get-Module ExchangeOnlineManagement -ListAvailable) | where {$_.Version.major -ge 3}
if($Module.count -eq 0)
{
 Write-Host Exchange Online PowerShell module is not available -ForegroundColor yellow
 $Confirm= Read-Host Are you sure you want to install module? [Y] Yes [N] No
 if($Confirm -match "[yY]")
 {
 Write-host "Installing Exchange Online PowerShell module"
 Install-Module ExchangeOnlineManagement -Repository PSGallery -AllowClobber -Force
 Import-Module ExchangeOnlineManagement
 }
 else
 {
 Write-Host EXO module is required to connect Exchange Online. Please install module using Install-Module ExchangeOnlineManagement cmdlet.
 Exit
 }
}
 
Write-Host `Connecting to Exchange Online...
Connect-ExchangeOnline

Write-Host "Script executed successfully & Exchange Online Connected Successfully!"

# Output will be added to C:\temp folder. Open the Remove-SMTP-Address.log with a text editor. For example, Notepad.

Write-Host "Proceeding to execute script for removing alias in a bulk"

Start-Transcript -Path C:\temp\Remove-SMTP-Address.log -Append

# Get all mailboxes
$Mailboxes = Get-Mailbox -ResultSize Unlimited

# Loop through each mailbox
foreach ($Mailbox in $Mailboxes) {

    # Change @contoso.com to the domain that you want to remove
    $Mailbox.EmailAddresses | Where-Object { ($_ -clike "smtp*") -and ($_ -like "*@kloudguardian.com") } | 

    # Perform operation on each item
    ForEach-Object {

        # Remove the -WhatIf parameter after you tested and are sure to remove the secondary email addresses
        Set-Mailbox $Mailbox.DistinguishedName -EmailAddresses @{remove = $_ }

        # Write output
        Write-Host "Removing $_ from $Mailbox Mailbox" -ForegroundColor Green
    }
}

Stop-Transcript