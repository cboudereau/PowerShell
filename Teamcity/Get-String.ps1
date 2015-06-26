function Get-String()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(
            Position=0, 
            Mandatory=$true)
        ]

        [string] $Accept,

        [Parameter(
                Position=1, 
                Mandatory=$true, 
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true)
            ]
        [string] $Uri
    )

    Process
    {
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.add('accept',$Accept)
        $creds = new-object System.Net.NetworkCredential("restapi","restapi")
        $webClient.Credentials = $creds
        
        return $webClient.DownloadString($uri)
    }
}