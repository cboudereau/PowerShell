function Get-TeamCityUri()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(
            Position=0, 
            Mandatory=$true, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
        ]
        $RelativePath
    )

    
    Process
    {
        if($env:TEAMCITY)
        {
            $root = New-Object -TypeName System.Uri -ArgumentList @($env:TEAMCITY)
            $controller = New-Object -TypeName System.Uri -ArgumentList @($root, $RelativePath)
            
            return $controller.AbsoluteUri
        }
        else
        {
            Write-Error "TeamCity Server is not set, you should use Set-Server to set the TeamCity server address"
        }
    }
}