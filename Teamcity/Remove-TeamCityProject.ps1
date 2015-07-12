function Delete-TeamCityProject()
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
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