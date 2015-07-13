function Download-AllArtifacts()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [string] $Directory = 'download',

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        $BuildId,
        
		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        $BuildTypeId,

		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('number')]
        $BuildNumber
	)

    Process
    {
        $selector = "/repository/downloadAll/$BuildTypeId/$BuildId`:id/artifacts.zip"
        $uri = $selector | Get-TeamCityUri

        $credential = Get-TeamCityCredential

        Download-File -Credential $credential -Uri $uri -Folder "download/$BuildTypeId/$BuildNumber"
    }
}