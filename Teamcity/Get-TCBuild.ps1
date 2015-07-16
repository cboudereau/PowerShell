function Get-TCBuild
{
    <#
       .SYNOPSIS
       Get the build for a given build type

       .DESCRIPTION
       Get the build object when a buildtype is given into the pipeline or when the id is set to a corresponding buildtype.
       This parameter is autocompleted by fetching buildtype on TeamCity server.

       .PARAMETER Id
       Mandatory, Given a buildType (also called build configuration). This parameter is the build type id (Value by property name).

       .PARAMETER Status
       Can be ALL, SUCCESS or FAILURE. When this parameter is set the cmdlet return all build type with the given status

       .PARAMETER Tags
       Contains list of tag. When this parameter is set, return the build corresponding to the given tags

       .PARAMETER Pinned
       Switch parameter, when this switch is set, the cmdlet return the pin builds

       .PARAMETER SinceLastSuccessful
       Can be used to see new problems. When there is new build failure when environment contain any failed builds.

       .PARAMETER Running
       Switch parameter; when it is set, return running builds for a given buildtype.

       .PARAMETER Canceled
       Switch parameter; when it is set, return canceled builds for a gieven buildtype.

       .PARAMETER Last
       Switch, when it set, return the last build. This functionnality use the TeamCity LookupLimit to 1

       .PARAMETER LookupLimit
       Given a looup limit, return build corresponding to the given build type limited to the lookup limit count.

       .EXAMPLE
       C:\PS> Get-TCBuildType Net_Framework | Get-TCBuild
    #>
    
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [string] $BuildType,

        [ValidateSet('ALL','SUCCESS','FAILURE')]
        [string] $Status,

        [string[]] $Tags,
        
        [switch] $Pinned,

        [switch] $SinceLastSuccessful,

        [switch] $Running,

        [switch] $Canceled,

        [string] $Number,

        [switch] $Last,

        [string] $LookupLimit,

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


Register-ParameterCompleter -CommandName 'Get-TCBuild' -ParameterName 'BuildType' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-TCBuildType).buildType | Where-Object {$_.id -like "*$wordToComplete*"} | ForEach-Object { New-CompletionResult $_.id -ToolTip ('{0} ({1})' -f $_.name, $_.id )}
}