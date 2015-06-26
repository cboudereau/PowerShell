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
        $Credential = Get-TeamCityCredential $Credential
        $server = Get-Server
        
        if($BuildType -eq "") 
        {
            return Get-FromJson $server $Credential
        }

        return Get-FromJson $server/id:$BuildType $Credential
    }
}

Register-ParameterCompleter -CommandName 'Get-BuildType' -ParameterName 'BuildType' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-BuildType).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}