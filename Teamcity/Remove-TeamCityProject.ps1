function Remove-TeamCityProject()
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
            $uri = "projects/id:$Id" | Get-TeamCityUri
            $credential = Get-TeamCityCredential -Credential $Credential

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

Register-ParameterCompleter -CommandName 'Remove-TeamCityProject' -ParameterName 'Id' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-TeamCityProject) | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name,$_.id )}
}