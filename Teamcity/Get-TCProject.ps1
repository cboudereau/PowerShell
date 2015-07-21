<#
    .SYNOPSIS
    Get the project type TeamCity object

    .DESCRIPTION
    Return the teamcity projects for the configured server.
    Parameters are autocompleted by retrieving project from teamcity server.

    .PARAMETER Project
    Mandatory, Also called Id, This parameter is autocomplete.

    .PARAMETER Server
    Set the teamcity server

    .EXAMPLE
    C:\PS> Get-TCProject Net

    .EXAMPLE
    C:\PS> Get-TCProject Net | New-TCProject FSharp.Data
#>
function Get-TCProject
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [string] $Project,
        
        [pscredential] $Credential,

        [string] $Server
    )

    Process
    {
        if($Project)
        {
            return Get-TCResource -Credential $Credential -Href projects/id:$Project -Server $Server
        }
        
        return (Get-TCResource -Credential $Credential -Href projects -Server $Server).project
    }
}

Register-ParameterCompleter -CommandName 'Get-TCProject' -ParameterName 'Project' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-TCProject) | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name,$_.id )}
}