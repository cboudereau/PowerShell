function Get-TCBuildType
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(ValueFromPipelineByPropertyName)]
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
            return $buildTypes | ForEach-Object { Get-TCResource -Credential $Credential -Href buildTypes/id:$_ }
        }

        return Get-TCResource -Href buildTypes -Credential $Credential
    }
}

Register-ParameterCompleter -CommandName 'Get-TCBuildType' -ParameterName 'BuildType' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-TCBuildType).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}