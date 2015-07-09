function Download-AllArtifacts()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Position=0, Mandatory=$false)]
        [string] $Directory = 'download',

        [Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $Build
    )

    Process
    {
        $buildId = $Build.id
        $buildTypeId = $Build.buildTypeId
        $buildNumber = $Build.number
        $selector = "repository/downloadAll/$buildTypeId/$buildId`:id/artifacts.zip"
        $uri = $selector | Get-TeamCityUri -BasePath ""

        $credential = Get-TeamCityCredential

        Download-File -Credential $credential -Uri $uri -Folder "download/$buildTypeId/$buildNumber"
    }
}