﻿@{

# Script module or binary module file associated with this manifest
ModuleToProcess = 'Teamcity.psm1'

# Version number of this module.
ModuleVersion = '1.0'

# ID used to uniquely identify this module
GUID = 'A6947C1A-3531-4E93-AFCF-85B8B898529D'

# Author of this module
Author = 'Clément Boudereau'

# Company or vendor of this module
CompanyName = '@cboudereau'

# Copyright statement for this module
Copyright = '2015'

# Description of the functionality provided by this module
Description = 'Provides PowerShell Teamcity command line interface.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '3.0'

# Name of the Windows PowerShell host required by this module
PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
PowerShellHostVersion = ''

# Minimum version of the .NET Framework required by this module
DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
CLRVersion = ''

# Processor architecture (None, X86, Amd64, IA64) required by this module
ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module
ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @('Teamcity.format.ps1xml')

# Modules to import as nested modules of the module specified in ModuleToProcess
NestedModules = @()

# Functions to export from this module
FunctionsToExport = @(
'Download-TCArtifacts'
'Get-TCBadge'
'Get-TCBuild'
'Get-TCBuildStatus'
'Get-TCBuildType'
'Get-TCChange'
'Get-TCProject'
'Get-TCWebLink'
'Get-TCTemplate'
'New-TCBuildType'
'New-TCFromTemplate'
'New-TCProject'
'Pin-TCBuild'
'Remove-TCBuildType'
'Remove-TCProject'
'Set-TCServer'
'Start-TCBuild'
'Tag-TCBuild'
)

# Cmdlets to export from this module
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module
AliasesToExport = @()

# List of all modules packaged with this module
ModuleList = @()

# List of all files packaged with this module
FileList = @()

# Private data to pass to the module specified in ModuleToProcess
PrivateData = ''

}

