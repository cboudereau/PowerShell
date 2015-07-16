function Download-TCArtifacts
{
        <#
       .SYNOPSIS
        Download the zip artifacts.

       .DESCRIPTION
        When a build is finished, it produce artifact that can be zipped by TeamCity.
        Given a finished build, then this cmdlet download the artifacts as zip.

       .PARAMETER Directory
       This parameter is set to download. This directory is created if doesn't exist.
       The Directory folder is classed by /Directory/BuildTypeId/BuildNumber

       .PARAMETER BuildId
       Is the BuildId of the Build object into the pipeline (Value by property name)

       .PARAMETER BuildTypeId
       Is the BuildTypeId of the Build object into the pipeline (Value by property name)

       .PARAMETER BuildNumber
       Is the BuildNumber (also aliased number) of the Build object into the pipeline (Value by property name)

       .EXAMPLE
       C:\PS> Get-TCBuildType Net_Framework | Get-TCbuild

       Get Only one change

       .EXAMPLE
       C:\PS> Get-TCBuildType Net_Framework | Get-TCBuild -Last -Status SUCCESS | Download-TCArtifacts
       
       Download artifacts from the last succesful build Net_Framework

    #>
    
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
        $uri = $selector | Get-TCUri

        $credential = Get-TCCredential

        Download-TCFile -Credential $credential -Uri $uri -Folder "download/$BuildTypeId/$BuildNumber"
    }
}