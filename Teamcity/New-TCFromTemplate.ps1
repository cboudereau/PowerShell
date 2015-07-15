function New-TCFromTemplate
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
        $template = Get-TCBuildType -BuildType $TemplateId
        $buildType = New-TCBuildType -ProjectId $ProjectId -Name $template.name -Credential $Credential
        $uri = Get-TCUri -RelativePath "buildTypes/id:$($buildType.id)/template"
        $credential = Get-TCCredential -Credential $Credential

        Post-String -Accept 'application/json' -ContentType 'text/plain' -Credential $credential -Uri $uri -Method PUT -Text $TemplateId | Out-Null
        Write-Host "$($buildType.name) was successfully created on project $ProjectId based on template $($template.id)"
        $buildType
    }
}

Register-ParameterCompleter -CommandName 'New-TCFromTemplate' -ParameterName 'TemplateId' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-TCTemplate) | % { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}