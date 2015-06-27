function Post-String()
{
   [CmdletBinding()]
    Param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $ContentType,

        [Parameter(Position=1, Mandatory=$true)]
        [pscredential] $Credential,

        [Parameter(Position=2, Mandatory=$true)]
        [string] $Uri,

        [Parameter(Position=3, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $Data
    )

    Process
    {
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.add('Content-Type', $ContentType)
        $webclient.Credentials = $Credential
        
        $webClient.UploadData($Uri, [system.Text.Encoding]::UTF8.GetBytes($Data)) | Out-Null
    }
}