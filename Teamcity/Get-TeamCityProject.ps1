function Get-TeamCityProject()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string] $Project,
        
        [Parameter(Mandatory=$false)]
        [switch] $BuildType,

        [Parameter(Mandatory=$false)]
        [pscredential] $Credential
    )

    Process
    {
        $credential = Get-TeamCityCredential $Credential
        $uri = "projects" | Get-TeamCityUri
        
        if(!$Project) 
        {
            return (Get-FromJson $credential $uri).project
        }

        if($BuildType)
        {
            return (Get-FromJson $credential $uri/id:$Project).buildTypes.buildType
        }

        return (Get-FromJson $credential $uri/id:$Project)
    }
}

Register-ParameterCompleter -CommandName 'Get-TeamCityProject' -ParameterName 'Project' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-TeamCityProject) | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}