# Powershell script to get the number of files greater than a given time period(in minutes) in the given share/directory and 
# format the message in a way that Zabbix can interpret

param (
    [string]$path = $(write-host "ERROR: -path <path> is required"),
    [Parameter(Mandatory=$false)][string]$duration,
    [Parameter(Mandatory=$false)][string]$exclude,
    [Parameter(Mandatory=$false)][string]$include
)

if(!($duration)){
    $duration = 5
}

write-host $exclude + $include 

$buildIncludeExcludecmd = ""
if($exclude){
    $buildIncludeExcludecmd = '-exclude ' + $exclude
    write-host $buildIncludeExcludecmd
}
if($include){
    $buildIncludeExcludecmd = $buildIncludeExcludecmd + ' -include ' + $include
    write-host $buildIncludeExcludecmd
}

$val = get-childitem $path -recurse $buildIncludeExcludecmd
write-host $val
$files = get-childitem $path -recurse $buildIncludeExcludecmd | where {$_.LastWriteTime -lt (Get-Date).AddMinutes(-$duration)} | 

Measure-Object
return $files.count
