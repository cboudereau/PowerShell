function Get-TeamCityWebLink()
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
        $uri = Get-TeamCityUri -RelativePath "/viewType.html?buildTypeId=$Id"
        Write-Host $uri
    }
}

Register-ParameterCompleter -CommandName 'Get-TeamCityWebLink' -ParameterName 'Id' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-BuildType).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}