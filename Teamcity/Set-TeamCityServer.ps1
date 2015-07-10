function Set-TeamCityServer()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $Uri = "http://localhost:7777/"
    )

    Process
    {
        $env:TEAMCITY = $Uri

        Write-Host "Server is : $Uri" 
    }
}