# 🛠️ Build Scripts
This repository contains reusable PowerShell scripts designed to automate version management in .NET SDK-style projects.
These scripts are intended for use in CI/CD pipelines (e.g., GitHub Actions) or local development workflows.

---

## 📜 Scripts

### 1. `Update-Version.ps1`
🔁 Increments a semantic version string (`major.minor.revision`) with rollover logic.

#### ✅ Features
- Supports pre-release and build metadata (e.g., `1.2.3-beta+build123`).
- Rollover logic for revision and minor thresholds.
- Returns the next version string.

#### 🧪 Example

```powershell
.\Update-Version.ps1 -Version "1.2.9" -Verbose
```

**Output:**
```
VERBOSE: Version          : 1.2.9
VERBOSE: RevisionThreshold: 9
VERBOSE: MinorThreshold   : 9
VERBOSE: New version      : 1.3.0
```

#### 📥 Parameters
Name                |Type   |Description
--------------------|-------|-------------------------------------------------------
Version             |string |Required. Semantic version string (e.g., 1.2.3)
RevisionThreshold   |int    |Optional. Max revision before rolling over (default: 9)
MinorThreshold      |int    |Optional. Max minor before rolling over (default: 9)

### 2. `Update-ProjectVersion.ps1`
📝 Updates the `<Version>`, `<AssemblyVersion>`, and `<FileVersion>` elements in a `.csproj` file.

#### 🧪 Example
```powershell
.\Update-ProjectVersion.ps1 -ProjectPathname "./MyApp/MyApp.csproj" -Version "2.0.0" -Verbose
```
**Output:**
```
VERBOSE: ProjectPathname  : ./MyApp/MyApp.csproj
VERBOSE: Version          : 2.0.0
VERBOSE: Normalized ProjectPathname : D:\Path\To\MyApp.csproj
VERBOSE: Updating project version in 'D:\Path\To\MyApp.csproj' to '2.0.0'.
VERBOSE: Updated 'D:\Path\To\MyApp.csproj' with version '2.0.0'.
```

#### 📥 Parameters
Name            |Type   |Description
----------------|-------|-----------------------------------------------
ProjectPathname |string |Required. Path to the .csproj file
Version         |string |Required. Semantic version string (e.g., 1.2.3)


## 🔁 Versioning
This repository uses semantic versioning for its own tags (e.g. `v1.0.0`).
Consumers should pin to a specific tag or commit in their workflows to ensure stability.

## 🚀 Usage in GitHub Actions
To use these scripts in another repository:

1. Clone this repo in your workflow:
```yml
- name: Checkout build scripts
uses: actions/checkout@v4
with:
    repository: your-username/build-scripts
    ref: v1.0.0
    path: build-scripts
    token: ${{ secrets.SCRIPT_REPO_TOKEN }}  # if private
```
2. Call the scripts in your workflow:
```yml
- name: Calculate new version
  shell: pwsh
  run: |
    $NewVersion = ./build-scripts/Update-Version.ps1 -Version $env:LATEST_VERSION
    echo "VERSION=$NewVersion" >> $env:GITHUB_ENV
```

## ✅ Testing
Scripts are validated automatically via GitHub Actions.
See `.github/workflows/test.yml` for details.

## 🧪 Local Testing
To run tests locally, execute:
```powershell
./Tests/Test-Update-Version.ps1
./Tests/Test-Update-ProjectVersion.ps1
```

**Note:**
If those files are updates, `./github/workflows/test.yml` must be updated accordingly.
