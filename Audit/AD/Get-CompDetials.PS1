$FTservers =@()
$OUSearchBase = "OU=Windows Servers,DC=ad,DC=ft,DC=com"
$OUexclusion = "Windows Servers", "ZZZ - Computers to be deleted"

$ous = Get-ADOrganizationalUnit -SearchBase $OUSearchBase -SearchScope Subtree -Filter *

ForEach($ou in $ous){

if ($OUexclusion -NotContains "$($ou.name)"){
   write-host "$ou.name in loop"

   $FTservers += $(Get-ADComputer -filter * -SearchBase $ou.DistinguishedName -properties * )|
   Select-Object @{n='ou';e={$ou.name}}, *
   }
}

$FTservers | Export-Clixml -Path .\FTServers.xml

$FTservers = import-Clixml -Path .\FTServers.xml
$OUTPUT= $FTservers[0..2] | ForEach-Object{
$compname = $_.name
$os = $_.operatingSystem
$lastlogon = [datetime]::FromFileTime($_.lastLogon)

try{
   $res = Invoke-Command -ComputerName $($_.Name) -ScriptBlock {$($psversiontable.psversion).Major}
   $res1 = Invoke-Command -ComputerName $($_.Name) -ScriptBlock {
     $Registry_Key ="Software\Microsoft\Windows NT\CurrentVersion\Winlogon\"
     Cd HKLM:\$Registry_Key
     Get-ItemProperty -Path. -Name DefaultUserName

   "" | Select-Object @{name="psversion";e={$res}}, @{name ="ComputerName";e={$compname}}, @{name ="OS";e={$os}}, @{name ="LastLogon";e={$lastlogon}} , @{name ="regkey";e={$res1}
}
catch{
   "" | Select-Object @{name="psversion";e={"N/A"}}, @{name ="ComputerName";e={$compname}}, @{name ="OS";e={$os}}, @{name ="LastLogon";e={$lastlogon}} , @{name ="regkey";e={"N/A"}
}

}

$output | Select-Object computername, psversion, os, LastLogon, regkey  @{name="ping";e={$(Test-Connection ($_.computername) -count 1 -quiet)}} | Export-csv -NoTypeInformation .\Computers.csv
