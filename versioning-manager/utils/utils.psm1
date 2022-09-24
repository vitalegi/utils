function getVersion($filepath, $regex) {
   $content = Get-Content $filepath -Raw | Select-String -Pattern $regex
   return $content.matches.groups[1].Value
}

function updateVersion($filepath, $regex, $newVersion) {
    Write-Output "Update $($filepath) version to $($newVersion)"
}

function pressKeyToContinue() {
    Write-Host 'Press any key to continue...';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}

function getMainBranch() {
    $master = Read-Host "Main branch? (develop/master/release) [develop]"
    if ($master -eq '') {
        $master = 'develop'
    }
    return $master
}