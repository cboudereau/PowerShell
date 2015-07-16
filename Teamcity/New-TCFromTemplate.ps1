<#
    .SYNOPSIS
    Create a new build type (build configuration) based on a given teamcity template.

    .DESCRIPTION
    Given a parent project and a template then create a build type (build configuration) same called as template under parent project

    .PARAMETER ProjectId
    Mandatory, aliased Id is the project where is hosted the build configurations

    .EXAMPLE
    C:\PS> Get-TCProject Net | New-TCProject Fsharp.Temporality | New-TCFromTemplate Net_Build
#>
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