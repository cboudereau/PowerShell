function New-FromTemplate()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory)]
        [string] $TemplateId,
        
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [string] $ProjectId,
        
        [pscredential] $Credential
    )

    Process
    {
        $template = Get-BuildType -BuildType $TemplateId
        $buildType = Create-BuildType -ProjectId $ProjectId -Name $template.name -Credential $Credential
        $uri = Get-TeamCityUri -RelativePath "buildTypes/id:$($buildType.id)/template"
        $credential = Get-TeamCityCredential -Credential $Credential

        Post-String -Accept 'application/json' -ContentType 'text/plain' -Credential $credential -Uri $uri -Method PUT -Text $TemplateId
    }
}

Register-ParameterCompleter -CommandName 'New-FromTemplate' -ParameterName 'TemplateId' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-Template) | % { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}