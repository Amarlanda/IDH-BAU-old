$FTcomputers = Get-ADComputer -filter * -SearchBase "OU=Windows Servers,DC=ad,DC=ft,DC=com"

$found=@{}
$FTcomputers | ForEach-Object{
$currentObj = $_

try
    {
        $errorActionPreference = "Stop"
        $result = Invoke-Command -ComputerName $($currentObj.Name) { 1 }
        $currentobj = $currentobj | select *, @{n='PSremoting';e={"True"}}
        $found.add($currentObj.Name,$currentobj)
        "success $($currentobj.name)!"
    }
    catch
    {
        $currentobj = $currentobj | select *, @{n='PSremoting';e={"False"}}
        $found.add($currentObj.Name,$currentobj)
         "Failed $($currentobj.name)!"
    }

    if($result -ne 1) ## great way to check for errors
    {
        Write-Verbose "Remoting to $computerName returned an unexpected result."
        return $result
    }
}
