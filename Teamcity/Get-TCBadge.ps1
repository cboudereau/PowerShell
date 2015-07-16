function Get-TCBadge
{
    <#
       .SYNOPSIS
        Copy to clipboard the TeamCity build badge

       .DESCRIPTION
        When a build is finished, TeamCity display a state SUCCESS, FAILURE or UNKNOWN when cancelled.
        This cmdlet display the build state for the last build for a given buildType

       .PARAMETER Id
       Mandatory, Given a buildType (also called build configuration). This parameter is the build type id (Value by property name).

       .EXAMPLE
       C:\PS> Get-TCBuildType Net_Framework | Get-TCBadge
    #>
    
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Id,

        [pscredential] $Credential
    )

    Process
    {
        $uri = Get-TCUri -RelativePath "builds/buildType:(id:$Id)/statusIcon"
        Write-Output $uri | clip
        Write-HostInfo "copied to clipboard!"
        Write-Host $uri
    }
}

Register-ParameterCompleter -CommandName 'Get-TCBadge' -ParameterName 'Id' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-TCBuildType).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}