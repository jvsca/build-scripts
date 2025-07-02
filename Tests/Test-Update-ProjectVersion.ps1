# Create a dummy .csproj file.
$ProjectPathname = "./TestApp/TestApp.csproj"
New-Item -ItemType Directory -Path "./TestApp" -Force | Out-Null
@"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net9.0</TargetFramework>
    <Version>0.0.0</Version>
    <AssemblyVersion>0.0.0</AssemblyVersion>
    <FileVersion>0.0.0</FileVersion>
  </PropertyGroup>
</Project>
"@ | Set-Content $ProjectPathname

$Version = '2.0.0'
$ScriptFilename = 'Update-Version.ps1'

& "./$ScriptFilename" -ProjectPathname $ProjectPathname -Version $Version

# Define the tags to update.
$VersionTags = @('Version', 'AssemblyVersion', 'FileVersion')

# Validate the version was updated.
[xml]$Xml = Get-Content $ProjectPathname
foreach ($Tag in $VersionTags)
{
    $ResultVersion = $Xml.Project.PropertyGroup.$Tag
    if ($ResultVersion -notmatch $Version)
    {
      throw "Version was not updated correctly for tag '$Tag'."
    }
    Write-Host "Version updated successfully for tag '$Tag'."
}
