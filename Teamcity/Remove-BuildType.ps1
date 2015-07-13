function Remove-BuildType()
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
            $uri = "buildTypes/id:$Id" | Get-TeamCityUri
            $credential = Get-TeamCityCredential -Credential $Credential

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

Register-ParameterCompleter -CommandName 'Remove-BuildType' -ParameterName 'Id' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-BuildType).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}