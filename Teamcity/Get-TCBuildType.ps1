<#
    .SYNOPSIS
    Get the build type TeamCity object

    .DESCRIPTION
    Build Type also called Build Configuration in TemaCity web interface can be retrieved thanks to autocompletion feature. Juste type the Get-TCBuildType then space and tab to autocomplete the build configuration with TeamCity server build configuration

    .PARAMETER BuildType
    Mandatory, also called buildTypes or id
    When it is called to the pipeline with Get-TCProject, it will return all build type for a given project.
    WHen it is called independently, the autocompletion feature give the build type to get.

    .EXAMPLE
    C:\PS> Get-TCBuildType Net_Framework

    .EXAMPLE
    C:\PS> Get-TCProject Net | Get-TCBuildType
#>
function Get-TCBuildType
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('buildTypes','id')]
        $BuildType,
        
        [pscredential] $Credential
    )

    Process
    {
        if($BuildType)
        {
            if($BuildType.buildType)
            {
                $buildTypes = $BuildType.buildType | ForEach-Object { $_.id }
            }
            else
            {
                $buildTypes = @($BuildType)
            }
        }
    }
    End
    {
        if($buildTypes)
        {
            return $buildTypes | ForEach-Object { Get-TCResource -Credential $Credential -Href buildTypes/id:$_ }
        }

        return Get-TCResource -Href buildTypes -Credential $Credential
    }
}

Register-ParameterCompleter -CommandName 'Get-TCBuildType' -ParameterName 'BuildType' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-TCBuildType).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}