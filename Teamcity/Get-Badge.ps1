function Get-Badge()
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
        $uri = Get-TeamCityUri -RelativePath "/buildType:(id:$Id)/statusIcon"
        Write-Host $uri
    }
}

Register-ParameterCompleter -CommandName 'Get-Badge' -ParameterName 'Id' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-BuildType).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}