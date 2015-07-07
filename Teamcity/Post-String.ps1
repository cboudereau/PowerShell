function Post-String()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $ContentType,

        [Parameter(Position=1, Mandatory=$true)]
        [pscredential] $Credential,

        [Parameter(Position=2, Mandatory=$false)]
        [string] $Text,

        [Parameter(Position=3, Mandatory=$false)]
        [ValidateSet('POST','PUT','DELETE')]
        [string] $Method = 'POST',

        [Parameter(Position=4, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri

    )

    Process
    {
        $webClient = New-Object System.Net.WebClient
        
        $webClient.Headers.add('Accept', "application/json")
        $webClient.Headers.add('Content-Type', $ContentType)
        $webClient.Credentials = $Credential

        return $webClient.UploadString($Uri, $Method, $Text)
    }
}