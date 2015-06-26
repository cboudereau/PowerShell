function Get-Build()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [string] $BuildName
    )

    Process
    {
        $root = 'http://localhost:7777/httpAuth/app/rest/buildTypes'
        
        if($BuildName -eq "") 
        {
            return Get-FromJson $root
        }

        return Get-FromJson $root/id:$BuildName
    }
}

Register-ParameterCompleter -CommandName 'Get-Build' -ParameterName 'BuildName' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-Build).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}