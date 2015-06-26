function Get-Server()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
        ]
        $Name
    )

    
    Process
    {
        if($env:TEAMCITY)
        {
            return $env:TEAMCITY
        }
        else
        {
            Write-Error "TeamCity Server is not set, you should use Set-Server to set the TeamCity host"
        }
    }
}