$TenantId = "33227e13-4782-47ac-9543-62baa1a210a4"
$ClientId = "cc0d0f8e-9409-4cf9-a49d-3214509190a4"
$ClientSecret = "jVI8Q~R50nDxrjrhme8wMxYM7MHBZcZFn~23cb41"

$SecureClientSecret = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force

$Credential = New-Object System.Management.Automation.PSCredential -ArgumentList $ClientId, $SecureClientSecret

Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $Credential
#Connect-MgGraph -Scopes "User.Read.All","Directory.Read.All","AuditLog.Read.All"

$Days = 30
$CutoffDate = (Get-Date).AddDays(-$Days)


$Users = Get-MgUser -All `
    -Property Id,DisplayName,UserPrincipalName,UserType,AccountEnabled,LastPasswordChangeDateTime `
    -ConsistencyLevel eventual `
    -CountVariable Count


$FilteredUsers = $Users | Where-Object {
    $_.AccountEnabled -eq $true -and
    $_.UserType -eq "C" -and
    $_.LastPasswordChangeDateTime -ne $null -and
    ([datetime]$_.LastPasswordChangeDateTime -lt $CutoffDate)
}


$FilteredUsers | Select-Object `
    DisplayName,
    UserPrincipalName,
    UserType,
    @{Name="LastPasswordChangeDate"; Expression = { $_.LastPasswordChangeDateTime }} | Export-Csv "Users_Password_Not_Changed_30_Days.csv" -NoTypeInformation

Add-Type -AssemblyName System.Web
$randowmpass=[System.Web.Security.Membership]::GeneratePassword(16, 3)

#$FilteredUsers | Export-Csv `
 #   "CloudUsers_Password_Not_Changed_30_Days.csv" `
  #  -NoTypeInformation
