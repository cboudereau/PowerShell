function Get-BuildType()
{
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias('buildTypes','id')]
        $BuildType,
        
        [pscredential] $Credential
    )

    Process
    {
        if($BuildType)
        {
            if($BuildType.buildType)
            {
                $buildTypes = $BuildType.buildType | ForEach-Object { $_.id }
            }
            else
            {
                $buildTypes = @($BuildType)
            }
        }
    }
    End
    {
        if($buildTypes)
        {
            return $buildTypes | ForEach-Object { Get-TeamCityResource -Credential $Credential -RelativePath buildTypes/id:$_ }
        }

        return Get-TeamCityResource -RelativePath buildTypes -Credential $Credential
    }
}

Register-ParameterCompleter -CommandName 'Get-BuildType' -ParameterName 'BuildType' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-BuildType).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}