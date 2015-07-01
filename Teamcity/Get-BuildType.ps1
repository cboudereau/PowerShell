function Get-BuildType()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string] $BuildType,
        [Parameter(Mandatory=$false)]
        [pscredential] $Credential
    )

    Process
    {
        $credential = Get-TeamCityCredential $Credential
        $uri = "buildTypes" | Get-TeamCityUri
        
        if(!$BuildType) 
        {
            return (Get-FromJson $credential $uri).buildType
        }

        return (Get-FromJson $credential $uri/id:$BuildType)
    }
}

Register-ParameterCompleter -CommandName 'Get-BuildType' -ParameterName 'BuildType' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-BuildType) | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}