function Get-Solution()
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName)]
        [string] $Name = "",

        [string] $Path = '.',

        [pscredential] $Credential
    )

    Process
    {
        $Path = Resolve-Path $Path
        
        $solutions = Get-ChildItem -File -Filter "*$Name*.sln" -Path $Path

        if($solutions)
        {
            return $solutions
        }
        else
        {
            $parentPath = Join-Path -Path @($Path) -ChildPath "../" | Resolve-Path
            if($parentPath.Path -eq $Path)
            {
                Write-Warning "$Name solution not found"
                return
            }
            Get-Solution -Name $Name -Path $parentPath
        }
    }
}