function Get-TeamCityProject()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [string] $Project,
        
        [pscredential] $Credential
    )

    Process
    {
        if($Project)
        {
            return Get-TeamCityResource -Credential $Credential -RelativePath projects/id:$Project
        }
        
        return (Get-TeamCityResource -Credential $Credential -RelativePath projects).project
    }
}

Register-ParameterCompleter -CommandName 'Get-TeamCityProject' -ParameterName 'Project' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-TeamCityProject) | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name,$_.id )}
}