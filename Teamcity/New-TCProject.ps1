function New-TCProject
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [string] $ParentId = "_Root",
        
        [pscredential] $Credential
    )

    Process
    {
        $parent = [pscustomobject]@{ id=$ParentId }
        $project = [pscustomobject]@{ name=$Name; parentProject=$parent }

        $uri = "projects" | Get-TCUri
        $credential = Get-TCCredential -Credential $Credential

        Post-ToJson -Uri $uri -Credential $Credential -Data $project
        Write-Host "Project $($project.name) was successfully created on project $ParentId"
    }
}

Register-ParameterCompleter -CommandName 'New-TCProject' -ParameterName 'Name' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-Solution -Name $wordToComplete) | % { $_ -replace ".sln" } | % { New-CompletionResult $_ -ToolTip ($_)}
}