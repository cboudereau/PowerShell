function Get-TCProject
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
            return Get-TCResource -Credential $Credential -Href projects/id:$Project
        }
        
        return (Get-TCResource -Credential $Credential -Href projects).project
    }
}

Register-ParameterCompleter -CommandName 'Get-TCProject' -ParameterName 'Project' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-TCProject) | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name,$_.id )}
}