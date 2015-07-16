<#
    .SYNOPSIS
    Remove a project.

    .DESCRIPTION
    Remove a project. CmdLet use tab expansion in order to retrieve all projects from teamcity server

    .PARAMETER Id
    The Id property of the project object from the pipeline

    .EXAMPLE
    C:\PS> Remove-TCProject Net_FSharpTemporality
#>
function Remove-TCProject
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact="High")]
    Param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Id,
        
        [pscredential] $Credential
    )

    Process
    {
        if($PSCmdlet.ShouldProcess($Id))
        {
            $project = [pscustomobject]@{ id=$Id }
            $uri = "projects/id:$Id" | Get-TCUri
            $credential = Get-TCCredential -Credential $Credential

            try
            {
                Post-ToJson -Uri $uri -Credential $Credential -Data $project -Method DELETE
                Write-Host "Project $Id was successfully deleted"
            }
            catch
            {
                Write-Warning "Project $Id was not found"
            }
        }
    }
}

Register-ParameterCompleter -CommandName 'Remove-TCProject' -ParameterName 'Id' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-TCProject) | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name,$_.id )}
}