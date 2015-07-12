function New-TeamcityProject()
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string] $Name,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias('id')]
        [string] $ParentId = "_Root",
        
        [pscredential] $Credential
    )

    Process
    {
        $parent = [pscustomobject]@{ id=$ParentId }
        $project = [pscustomobject]@{ name=$Name; parentProject=$parent }

        $uri = "projects" | Get-TeamCityUri
        $credential = Get-TeamCityCredential -Credential $Credential

        Post-ToJson -Uri $uri -Credential $Credential -Data $project
        Write-Host "Project $($project.name) was successfully created on project $ParentId"
    }
}

Register-ParameterCompleter -CommandName 'New-TeamcityProject' -ParameterName 'Name' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-Solution -Name $wordToComplete) | % { $_ -replace ".sln" } | % { New-CompletionResult $_ -ToolTip ($_)}
}