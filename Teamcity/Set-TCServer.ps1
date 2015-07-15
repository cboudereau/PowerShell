function Set-TCServer
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $Uri = "http://localhost:7777/"
    )

    Process
    {
        $env:TEAMCITY = $Uri

        Write-Host "Server is : $Uri" 
    }
}