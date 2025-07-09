Connect-MsolService

$email = Import-Csv C:\Users\ism\Desktop\PasswordReset.csv
$userid = $email.User

foreach($id in $userid)
{
    $pass = Set-MsolUserPassword -UserPrincipalName $id -ForceChangePassword $True

    [PSCustomObject]@{
        Email_ID = $id
        Password = $pass
    }| Export-Csv -Path C:\Users\ism\Desktop\Newpassword.csv -Append -NoTypeInformation

}
