function Get-Build()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string] $BuildName,
        [Parameter(Mandatory=$false)]
        [pscredential] $Credential
    )

    Process
    {
        $Credential = Get-TeamCityCredential $Credential
        $server = Get-Server
        
        if($BuildName -eq "") 
        {
            return Get-FromJson $server $Credential
        }

        return Get-FromJson $server/id:$BuildName $Credential
    }
}

Register-ParameterCompleter -CommandName 'Get-Build' -ParameterName 'BuildName' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-Build).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}