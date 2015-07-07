function Get-Builds()
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('ALL','SUCCESS','FAILURE','ERROR')]
        [string] $Status,

        [string[]] $Tags,
        
        [switch] $Pinned,

        [string] $Number,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('id')]
        [string] $BuildType,

        [pscredential] $Credential
    )

    Process
    {
        $number = if($Number) { ",number:$Number" } else { "" }
        $request = "?locator=buildType:(id:$BuildType)$number"

        if($Status -and $Status -ne 'ALL')
        {
            $request += ",status:$Status"
        }
        
        if($Tags)
        {
            $tags = [string]::Join(',',$Tags)
            $request += ",tags:($tags)"

        }
        
        if($Pinned)
        {
            $request += ",pinned:$Pinned"
        }

        $selector = "builds/$request"
        $uri = $selector | Get-TeamCityUri

        (Get-TeamCityResource -Credential $Credential -RelativePath $uri).build
    }
}