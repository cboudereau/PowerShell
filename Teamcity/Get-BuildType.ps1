function Get-BuildType()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string] $BuiltType,
        [Parameter(Mandatory=$false)]
        [pscredential] $Credential
    )

    Process
    {
        $Credential = Get-TeamCityCredential $Credential
        $server = Get-Server
        
        if($BuiltType -eq "") 
        {
            return Get-FromJson $server $Credential
        }

        return Get-FromJson $server/id:$BuiltType $Credential
    }
}

Register-ParameterCompleter -CommandName 'Get-BuildType' -ParameterName 'BuiltType' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-Build).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}