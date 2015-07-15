function Get-String
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory)]
        [string] $Accept,

        [Parameter(Mandatory)]
        [pscredential] $Credential,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Uri
    )

    Process
    {
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.add('accept',$Accept)
        $webClient.Credentials = $Credential
        
        return $webClient.DownloadString($uri)
    }
}