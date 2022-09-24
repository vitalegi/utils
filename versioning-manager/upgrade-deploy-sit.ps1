if (Get-Module -ListAvailable -Name utils) {
    Remove-Module -Name utils
}
Import-Module $PSScriptRoot\utils

git checkout deploy/sit
git pull

# ask user which is the main branch
$master = getMainBranch

# retrieve current version
$oldVersion = getVersion 'versioning-manager\example-dev.json' '"version": "(.*)"'
Write-Output $oldVersion

# ask user for new version
Write-Output "Current version is $($oldVersion)"
$version = Read-Host 'Target version?'

Write-Output "Target branch is $($master)"
Write-Output "New version is $($version)"

pressKeyToContinue

# update version
updateVersion 'example-dev.json' 'rex' $version 
updateVersion 'main.json' 'rex' $version 

# commit
git add example-dev.json
git add main.json

Remove-Module -Name utils