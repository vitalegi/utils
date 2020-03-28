
function InitPom($srcFile, $destFile, $groupId, $artifactId, $version) {

    echo "Init Pom $destFile with: $groupId, $artifactId, $version";
    copy $srcFile $destFile
    (Get-Content -path $destFile -Raw) -replace '@groupId@',$groupId | Set-Content -Encoding UTF8 -Path $destFile
    (Get-Content -path $destFile -Raw) -replace '@artifactId@',$artifactId | Set-Content -Encoding UTF8 -Path $destFile
    (Get-Content -path $destFile -Raw) -replace '@version@',$version | Set-Content -Encoding UTF8 -Path $destFile
}

function CreateDirIfNotExists($path) {
    If(!(test-path $path)) {
        echo "Create dir $path"
        New-Item -ItemType Directory -Path $path | Out-Null
    } else {
        echo "Dir $path already exists"
    }
}

function DeleteDirIfExists($path) {
    If(test-path $path) {
        echo "Delete $path"
        Remove-Item -Recurse -Force $path
    } else {
        echo "Dir $path doesn't exist"
    }
}

# set path to 7zip
$env:Path += ";C:\Program Files\7-Zip";

# Default folder to lookup for WAR files 
$default = "./versions"
if (!($defaultWarLocation = Read-Host "Lookup Folder [$default]")) { $defaultWarLocation = $default }


# Pick the last "Version_*" folder available and extract the version number
$default = Get-ChildItem "$defaultWarLocation/*" -Filter "Version_*" | sort LastWriteTime | select -last 1 -exp Name
$default = $default.substring("Version_".length)
if (!($targetVersion = Read-Host "Output version (e.g.: 1.2.3.4) [$default]")) { $targetVersion = $default }

# Folder that contains WAR files
$default = "$defaultWarLocation/Version_$targetVersion"
if (!($warDir = Read-Host "Folder that contains WAR [$default]")) { $warDir = $default }

echo "WAR files in: $warDir"
echo "Output version: $targetVersion"

# Init dirs
DeleteDirIfExists "./nexus1"
DeleteDirIfExists "./nexus2"
CreateDirIfNotExists "./nexus1/1"
CreateDirIfNotExists "./nexus1/2"
CreateDirIfNotExists "./nexus1/3"
CreateDirIfNotExists "./nexus2/1"
CreateDirIfNotExists "./nexus2/2"
CreateDirIfNotExists "./nexus2/3"
CreateDirIfNotExists "./nexus2/4"

# Create pom.xml files
InitPom "pom.xml" "./nexus1/1/test.xml" "group1" "artifact1" $targetVersion
InitPom "pom.xml" "./nexus1/2/test.xml" "group2" "artifact2" $targetVersion

# Copy WAR files to proper dir

# ZIP
7z a -tzip ./nexus1/nexus.zip ./nexus1/*
7z l ./nexus1/nexus.zip

7z a -tzip ./nexus2/nexus.zip ./nexus2/*
7z l ./nexus2/nexus.zip
