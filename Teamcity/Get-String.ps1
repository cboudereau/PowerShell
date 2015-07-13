function Get-String()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Position=0, Mandatory)]
        [string] $Accept,

        [Parameter(Position=1, Mandatory)]
        [pscredential] $Credential,

        [Parameter(Position=2, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
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