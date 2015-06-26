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
        $Data,

        [Parameter(Mandatory=$true)]
        [pscredential] $Credential

    )

    Process
    {
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.add('Content-Type', $ContentType)
        $webclient.Credentials = $Credential
        
        return $webClient.UploadData($Uri, [system.Text.Encoding]::UTF8.GetBytes($Data))
    }
}