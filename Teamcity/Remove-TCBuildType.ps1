function Remove-TCBuildType
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
            $buildType = [pscustomobject]@{ id=$Id }
            $uri = "buildTypes/id:$Id" | Get-TCUri
            $credential = Get-TCCredential -Credential $Credential

            try
            {
                Post-ToJson -Uri $uri -Credential $Credential -Data $buildType -Method DELETE
                Write-Host "BuildType $Id was successfully deleted"
            }
            catch
            {
                Write-Warning "BuildType $Id was not found"
            }
        }
    }
}

Register-ParameterCompleter -CommandName 'Remove-TCBuildType' -ParameterName 'Id' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-TCBuildType).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}