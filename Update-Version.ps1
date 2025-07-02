[CmdletBinding()]
Param
(
    [string]
    $Version,

    [int]
    $RevisionThreshold = 9,

    [int]
    $MinorThreshold = 9
)

<#
    .SYNOPSIS
    Increments a semantic version string (major.minor.revision) with rollover logic.

    .PARAMETER Version
    The version string to increment (e.g., 1.2.9).

    .PARAMETER RevisionThreshold
    The maximum value for the revision number before rolling over (default: 9).

    .PARAMETER MinorThreshold
    The maximum value for the minor number before rolling over (default: 9).

    .EXAMPLE
    pwsh > .\Update-Version.ps1 -Version 1.2.9 -Verbose
    VERBOSE: Version: 1.2.9
    VERBOSE: RevisionThreshold: 0
    VERBOSE: MinorThreshold: 0
    VERBOSE: New version: 2.0.0
#>
function Update-Version
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory,
                   HelpMessage = 'Provide a semantic version string (major.minor.revision) e.g.: 1.2.3.')]
        [ValidatePattern('^\d+\.\d+\.\d+(-[0-9A-Za-z-.]+)?(\+[0-9A-Za-z-.]+)?$')]
        [string]
        $Version,

        [int]
        $RevisionThreshold = 9,

        [int]
        $MinorThreshold = 9
    )

    Write-Verbose "Version          : $Version"
    Write-Verbose "RevisionThreshold: $RevisionThreshold"
    Write-Verbose "MinorThreshold   : $MinorThreshold"

    # Extract core version (ignore pre-release and build metadata).
    $coreVersion = $Version -replace '[-+].*$', ''
    $parts = $coreVersion -split '\.'
    $major = [int]$parts[0]
    $minor = [int]$parts[1]
    $revision = [int]$parts[2]

    # Increment version with rollover logic.
    $revision++
    if ($revision -gt $RevisionThreshold)
    {
        $revision = 0
        $minor++
        if ($minor -gt $MinorThreshold)
        {
            $minor = 0
            $major++
        }
    }

    $newVersion = "$major.$minor.$revision"

    Write-Verbose "New version      : $newVersion"

    return $newVersion
}

# If the script is executed directly with all the mandatory parameters, run the function.
if ($MyInvocation.InvocationName -ne '.' -and $Version)
{
    Write-Output (Update-Version -Version $Version -RevisionThreshold $RevisionThreshold -MinorThreshold $MinorThreshold)
}
