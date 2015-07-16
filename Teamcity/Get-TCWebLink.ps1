<#
    .SYNOPSIS
    Get the build type web url

    .DESCRIPTION
    Copy to clipboard the teamcity build type or configuration web url.

    .PARAMETER Id
    Mandatory, Correspond to a build configuration and autocompleted by retrieving teamcity build configuration from server.s

    .EXAMPLE
    C:\PS> Get-TCWebLink FSharp.Data
#>
function Get-TCWebLink
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Id,

        [pscredential] $Credential
    )

    Process
    {
        $uri = Get-TCUri -RelativePath "/viewType.html?buildTypeId=$Id"
        Write-Output $uri | clip
        Write-HostInfo "copied to clipboard!"
        Write-Host $uri
    }
}

Register-ParameterCompleter -CommandName 'Get-TCWebLink' -ParameterName 'Id' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-TCBuildType).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}