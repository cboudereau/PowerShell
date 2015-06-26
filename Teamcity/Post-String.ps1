function Post-String()
{
   [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string] $ContentType,

        [Parameter(Mandatory=$true)]
        [string] $Uri,

        [Parameter(Mandatory=$true)]
        $Data
    )

    Process
    {
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.add('Content-Type', $ContentType)
        $creds = new-object System.Net.NetworkCredential("restapi","restapi")
        $webclient.Credentials = $creds
        
        return $webClient.UploadData($Uri, [system.Text.Encoding]::UTF8.GetBytes($Data))
    }
}