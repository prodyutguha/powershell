$TenantId = "33227e13-4782-47ac-9543-62baa1a210a4"
$ClientId = "cc0d0f8e-9409-4cf9-a49d-3214509190a4"
$ClientSecret = "jVI8Q~R50nDxrjrhme8wMxYM7MHBZcZFn~23cb41"

$SecureClientSecret = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force

$Credential = New-Object System.Management.Automation.PSCredential -ArgumentList $ClientId, $SecureClientSecret

Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $Credential

$users = Get-MgUser -All

$results = foreach ($u in $users) {

    $managerRef = Get-MgUserManager -UserId $u.Id -ErrorAction SilentlyContinue

    if ($managerRef -eq $null) {
        
        $userid = Get-MgUser -UserId $u.Id | Select-Object Id, DisplayName

        $body = @{
                "@odata.id" = "https://graph.microsoft.com/v1.0/users/7a312e86-f048-4924-aa17-80026b661d15"
     }
                Set-MgUserManagerByRef -UserId $userid.Id -BodyParameter $body

    }
}
