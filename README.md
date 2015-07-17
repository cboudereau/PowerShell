# PowerShell

## How to Install Modules
Clone the repo and copy modules to the powershell module path.

To find powershell module path, in a powershell console enter $env:PSModulePath

This env variable contains all module reference path used to find module

To avoid import module repetition, use the profile.ps1 in the %USERPROFILE%\Documents\WindowsPowerShell\profile.ps1

In profile.ps1 write : 

```powsershell
	Import-Module PSCompletion
	Import-Module Teamcity
```

Folder structure : 
%USERPROFILE%\Documents\WindowsPowerShell

	|_ Modules
		|_ PSCompletion
			|_ ...
		|_ Teamcity
			|_ ...
	|_ profile.ps1

Get help from a command line

Get-Help Get-TCBuildType	

## PsCompletion Module (autocomplete argument thanks to @thinkbeforecoding)

Teamcity module: Get build type, builds, Start and pin build and more

IMPORTANT :
First you have to set TeamCity server by calling Set-TCServer. By default the uri parameter is http://localhost:7777/ for testing purpose

In all cmdlet we use Net_Framework, or other build types (Build configuration are called Build Type in TeamcityRest API). 
In your test you have to replace it or just let the Get-TCBuildTypes finding all TeamCity buildTypes from the configured server

## TeamCity Module

### Set-TCServer
Set the TeamCity Server to avoid server uri repetition. By default, Uri is set to http://localhost:7777/
Note : if you use httpAuth instead of guest, others cmdlet prompt the credential if not set. All cmdlet reuse same credential allong the powershell session.

```powershell
  Set-TCServer -Uri http://<your-teamcity-server>
```

### Get-TCProject
Get All or specified Project from the teamcity server. The Project parameter is autocompleted by getting the project list from the teamcity server.

Project parameter is the Project ID in the Teamcity project settings

```powershell
  # Tap tab to autocomplete parameter
  Get-TCProject "project blair witch"
  
  #or
  Get-TCProject -Project "project blair witch"
```

### New-TCProject
```powershell
  #Create Project at Root Level
  New-TCProject "ProjectBlairWitch"
  
  #Create Child Project
  Get-TCProject "NetProject" | New-TCBuildType "ProjectBlairWitch"
  
  #Given the current path c:\dev\MyProject which contains the file FSharp.Data.Portable7.sln
  #The autocomplete Name of this CmdLet will find all solutions name recursively when press tab
  #The result is a project in teamcity named FSharpDataPortable7 under Root project
  #This mode permit to call this cmdlet into VisualStudio Nuget powershell host
  cd c:\dev\MyProject
  New-TCProject FSharp.Data.Portable7
  
  #Under Parent project
  cd c:\dev\MyProject
  Get-TCProject Net | New-TCProject FSharp.Data.Portable7
  
  #Into VisualStudio Nuget Powershell Host
  #Create Project, add the build based on template and start it :) !
  Get-TCProject Net | New-TCProject FSharp.Data.Portable7 | New-TCFromTemplate Net_Build | Start-TCBuild -Wait

```

### Remove-TCProject
```powershell
  
  #Remove Project
  Remove-TCProject "NetProject"

  #or
  Get-TCProject "NetProject" | Remove-TCProject
```

### Get-TCBuildType 
Return all TeamCity build types, you can specify the buildType. BuildType is autocomplete with getting first all build types from teamcity server.
Note : The build type id is autogenerated by TeamCity.

```powershell
  #Get all build type from a project
  Get-TCProject -Project Net | Get-TCBuildType

  #Start a Build
  Get-TCBuildType -BuildType Net_Framework | Start-TCBuild

  #Get BuildType Net_Framework
  Get-TCBuildType -BuildType Net_Framework
```

### New-TCBuildType
```powershell
  #Remove Project
  Get-TCProject Net | New-TCBuildType -Name "Fsharp.Temporality"
```

### Remove-TCBuildType
```powershell
  #Remove Project
  Get-TCBuildType "Net_Framework" | Remove-TCBuildType
```

### Get-TCBuild
Get all builds for a given buildType

```powershell
  #Get all Succcessful builds
  Get-TCBuildType -BuildType Net_Framework | Get-TCBuild -Status SUCCESS
  
  #Get All Prod Tagged Successful builds
  Get-TCBuildType -BuildType Net_Framework | Get-TCBuild -Status SUCCESS -Tags @('Prod')
  
  #Get All pinned Successful builds
  Get-TCBuildType -BuildType Net_Framework | Get-TCBuild -Status SUCCESS -Pinned
  
  #Get a single build by build number
  Get-TCBuildType -BuildType Net_Framework | Get-TCBuild -Number 23
  
  #Get New Problems
  Get-TCProject | Get-TCBuildType | Get-TCBuild -Status FAILURE -SinceLastSuccessful
  
  #Then Start Build for new Problems :)
  Get-TCProject | Get-TCBuildType | Get-TCBuild -Status FAILURE -SinceLastSuccessful | Start-TCBuild -Wait
  
```
### Pin-TCBuild
Pin a given build
  
```powershell
  #Pin Build
  Get-TCBuildType -BuildType Net_HardMock_MainBuild | Get-TCBuild -Status SUCCESS -Last | Pin-TCBuild
  
  #Unpin build
  Get-TCBuildType -BuildType Net_HardMock_MainBuild | Get-TCBuild -Status SUCCESS -Last | Pin-TCBuild -Delete
```

### Tag-TCBuild

Tag a given build

```powershell
  #Add a tag
  Get-TCBuildType -BuildType Net_HardMock_MainBuild | Get-TCBuild -Status SUCCESS -Last | Tag-TCBuild -Tag 'Prod'
  
  #Delete ALL Tags
  Get-TCBuildType -BuildType Net_HardMock_MainBuild | Get-TCBuild -Status SUCCESS -Last | Tag-TCBuild -Delete
  
  #Combine Tag and Pin
  Get-TCBuildType -BuildType Net_HardMock_MainBuild | Get-TCBuild -Status SUCCESS -Last | Tag-TCBuild -Tag 'Prod' | Pin-TCBuild
```

### Start-TCBuild

```powershell
   #Start all builds and wait the result in a progressbar :)
   Get-TCBuildType | Start-TCBuild -Wait
```

### Get-TCChange
```powershell
   #Get Only one change
   Get-TCChange 25
   
   #Start all builds and wait the result in a progressbar :)
   Get-TCBuildType | Get-TCBuild -Last | Get-TCChange
```

### Generate Build from solution with template
You have to setup a template which the solution name is the single parameter of the build.
The solution name is bind to the project name.

```powershell
   #This cmdlet pipeline create a project called FSharp.Temporality into Net project with the template Net_Build.
   #Cmdlets Get-TCProject support autocomplete by getting Teamcity Projects, Create-Team
   #Goto to the folder containing the solution and  New-TCBuildType find the solution
   #New-TCFromTemplate create a build configuration with the same name as given template
   cd c:\sources\FSharp.Temporality
   Get-TCProject Net | New-TCBuildType FSharp.Temporality | New-TCFromTemplate Net_Build
   #In Teamcity there is Project Net > Project FSharp.Temporality > Build
```

### Get-TCBadge
Return the build badge from the build.
Url is copied to clipboard
```powershell
   Get-TCBuildBadge Net_Framework
```

### Get-TCWebLink
Return the web link from the build
Url is copied to clipboard
```powershell
   Get-TCWebLink Net_Framework
```

### Download-TCArtifacts
Download artifacts.zip of a build
Parameter Directory (target folder) can be specified. If Not, the directory download is created.
The artifact in downloaded under Directory/BuildType/BuildNumber folder
```powershell
   Get-TCBuildType Net_Framework | Get-TCBuild -Last -Status SUCCESS | Download-TCArtifacts
```

### Pipelining
  Thanks to PowerShell Pipeline, you can combine commands even if the output return a list. In this case an implicit foreach occurs on the next command. For example if the command Get-TCBuildTypes return 3 buildTypes then if you pipe to Start-TCBuild, the 3 buildType starts