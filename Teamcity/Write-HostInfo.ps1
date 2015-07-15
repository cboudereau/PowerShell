function Write-HostInfo
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Text
    )

    Process
    {
        Write-Host -BackgroundColor DarkCyan -ForegroundColor White $Text
    }
}