# Set the credentia
$User = 'admin'
$Pass = 'gEd1z3TZ@uI%'

# Set headers
$GlobalHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$GlobalHeaders.Add('Accept', 'application/json')
$GlobalHeaders.Add('Content-Type', 'application/json')

# Build & set authentication header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $User, $Pass)))
$GlobalHeaders.Add('Authorization', ('Basic {0}' -f $base64AuthInfo))

# Load variable with ServiceNow instance URL
$ServiceNowInstance = 'https://dev221711.service-now.com/'

# Load a variable with the incident table API endpoint
$CreateIncidentURL = "$ServiceNowInstance/api/now/table/incident"

# Service Desk assignment group sys_id
$AssignmentGroup = 'Test'

# Alan Ps1/contoso.administrator elevated user sys_id
#$ContosoAdministrator = 'b9427790db3620106426f36f299619bf' # contoso.administrator
$ContosoAdministrator = 'Prodyut Guha'

Function Add-Ticket {

    # Load a variable with data for the description field
    $MessageBody = "Here is some text ...`r`n`r`nYou could generate this data from anywhere.`r`nI will leave the rest to your imagination."
    # Load a variable with data for the short description field
    $ShortDescription = "New ticket logged from Powershell"
    
    # Splat some paramanters used for the body of the POST request
    $SNNewTicketData = @{
        short_description               = $ShortDescription
        description                     = $MessageBody
        category                        = "Software"
        u_type                          = "incident"
        assignment_group                = $AssignmentGroup
        caller_id                       = $ContosoAdministrator
    }

    # Splat some paramanters used for the POST request, Headers, Method, Uri all required
    # Body used to pass the fields I will pupulate within the ticket - there are several, see the docs
    $Params = @{
        Headers = $GlobalHeaders
        Method  = "POST"
        Uri     = $CreateIncidentURL
        Body    = ($SNNewTicketData | ConvertTo-Json)
    }

    # God practice, although in this example I am not handling any errors. Maybe you can to suit?
    Try {

        Invoke-WebRequest @Params -UseBasicParsing -ErrorAction Stop

    }
    Catch {

        # Handle any errors

    }

}

# Run the function, Add-Ticket
Add-Ticket