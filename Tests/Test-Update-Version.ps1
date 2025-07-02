$Version    = '1.2.3'
$NewVersion = '1.2.4'
$ScriptFilename = 'Update-Version.ps1'

$ResultVersion = & "./$ScriptFilename" -Version $Version
if (-not $ResultVersion)
{
    throw "'$ScriptFilename' did not return a value."
}

if ($ResultVersion -notmatch $NewVersion)
{
    throw "Version was not updated correctly, Expected = '$NewVersion', Actual = '{$ResultVersion}'."
}

 Write-Host "'$ScriptFilename' updated Version successfully from '{$Version}' to '{$ResultVersion}'."
