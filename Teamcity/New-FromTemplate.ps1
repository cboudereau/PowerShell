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
        $buildType = New-BuildType -ProjectId $ProjectId -Name $template.name -Credential $Credential
        $uri = Get-TeamCityUri -RelativePath "buildTypes/id:$($buildType.id)/template"
        $credential = Get-TeamCityCredential -Credential $Credential

        Post-String -Accept 'application/json' -ContentType 'text/plain' -Credential $credential -Uri $uri -Method PUT -Text $TemplateId | Out-Null
        Write-Host "$($buildType.name) was successfully created on project $ProjectId based on template $($template.id)"
        $buildType
    }
}

Register-ParameterCompleter -CommandName 'New-FromTemplate' -ParameterName 'TemplateId' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-Template) | % { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}