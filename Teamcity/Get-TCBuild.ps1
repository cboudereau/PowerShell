function Get-TCBuild
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [ValidateSet('ALL','SUCCESS','FAILURE')]
        [string] $Status,

        [string[]] $Tags,
        
        [switch] $Pinned,

        [switch] $SinceLastSuccessful,

        [switch] $Running,

        [switch] $Canceled,

        [string] $Number,

        [string] $LookupLimit,

        [switch] $Last,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
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

        if($SinceLastSuccessful)
        {
            $request +=",sinceBuild:(status:SUCCESS)"
        }

        if($Running)
        {
            $request +=",running:$Running"
        }

        if($Canceled)
        {
            $request +=",canceled:$Canceled"
        }

        if($Last)
        {
            $request +=",lookupLimit:1"
        }

        elseif($LookupLimit)
        {
            $request +=",lookupLimit:$LookupLimit"
        }
        

        $uri = "builds/$request"

        (Get-TCResource -Credential $Credential -Href $uri).build
    }
}