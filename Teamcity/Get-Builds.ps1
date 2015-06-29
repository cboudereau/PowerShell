function Get-Builds()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position=0, Mandatory=$false)]
        [ValidateSet('ALL','SUCCESS','FAILURE','ERROR')]
        $Status,

        [Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $BuildType
    )

    Process
    {
        if($Status -and $Status -eq -not 'ALL')
        {
            
        }
        else
        {
            Write-Host "Choose None or ALL"
        }
        
        $buildTypeId = $BuildType.id
        $uri = "buildTypes/id:$buildTypeId/builds" | Get-TeamCityUri
        $credential = Get-TeamCityCredential

        ($uri | Get-FromJson $credential).build
    }
}