function Delete-BuildType()
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