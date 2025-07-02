[CmdletBinding()]
Param
(
    [Parameter()]
    [string]
    $ProjectPathname,

    [Parameter()]
    [string]
    $Version
)

<#
    .SYNOPSIS
    Updates the version in a .csproj file to a specified version.

    .PARAMETER ProjectPathname
    The path to the .csproj file to update.

    .PARAMETER Version
    The version to set in the format major.minor.revision (e.g., 1.2.3).

    .NOTES
    This script is intended for SDK-style .csproj files and assumes no XML namespaces.

    .EXAMPLE
    .\Update-ProjectVersion.ps1 -ProjectPathname .\TCDCalendar.csproj -Version 8.3.2 -Verbose
    VERBOSE: ProjectPathname  : .\TCDCalendar.csproj
    VERBOSE: Version          : 8.3.2
    VERBOSE: Normalized ProjectPathname : D:\Users\jvs\Desktop\Update Versions\TCDCalendar.csproj
    VERBOSE: Updating project version in 'D:\Users\jvs\Desktop\Update Versions\TCDCalendar.csproj' to '8.3.2'.
    VERBOSE: Updated 'D:\Users\jvs\Desktop\Update Versions\TCDCalendar.csproj' with version '8.3.2'.
#>
function Update-ProjectVersion
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory,
                   HelpMessage = 'Provide the path to a .csproj file.')]
        [string]
        $ProjectPathname,

        [Parameter(Mandatory,
                   HelpMessage = 'Provide a semantic version string (major.minor.revision) e.g.: 1.2.3.')]
        [string]
        $Version
    )

    Write-Verbose "ProjectPathname  : $ProjectPathname"
    Write-Verbose "Version          : $Version"

    try
    {
        $ProjectPathname = Resolve-Path $ProjectPathname -ErrorAction Stop | Select-Object -ExpandProperty Path
        Write-Verbose "Normalized ProjectPathname : $ProjectPathname"
    }
    catch
    {
        throw "Failed to resolve path '$ProjectPathname'. Ensure the file exists and the path is valid."
    }

    # Check if the ProjectPathname exists.
    if (-not (Test-Path $ProjectPathname))
    {
        throw "The specified project file '$ProjectPathname' does not exist."
    }

    # Validate Version input format: major.minor.revision.
    if ($Version -notmatch '^\d+\.\d+\.\d+$')
    {
        throw "Invalid version format. Expected format: major.minor.revision."
    }

    Write-Verbose "Updating project version in '$ProjectPathname' to '$Version'."

    # Load the XML.
    try
    {
        [xml]$xml = Get-Content $ProjectPathname -ErrorAction Stop
    }
    catch
    {
        throw "Failed to load XML from '$ProjectPathname'. Ensure it is a valid .csproj file."
    }


    # Define the tags to update.
    $versionTags = @('Version', 'AssemblyVersion', 'FileVersion')

    # Update or add the version elements.
    foreach ($tag in $versionTags)
    {
        $updated = $false
        foreach ($propertyGroup in $xml.Project.PropertyGroup)
        {
            $node = $propertyGroup.$tag
            if ($node)
            {
                $propertyGroup.$tag = $Version
                $updated = $true
            }
        }
        if (-not $updated)
        {
            # Add to the first PropertyGroup if not found.
            $newElement = $xml.CreateElement($tag)
            $newElement.InnerText = $Version
            $xml.Project.PropertyGroup[0].AppendChild($newElement) | Out-Null
        }
    }

    # Save the updated XML back to the file.
    $xml.Save($ProjectPathname)
    Write-Verbose "Updated '$ProjectPathname' with version '$Version'."
}

# If the script is executed directly with all the mandatory parameters, run the function.
if ($MyInvocation.InvocationName -ne '.' -and $ProjectPathname -and $Version)
{
    Update-ProjectVersion -ProjectPathname $ProjectPathname -Version $Version
}
