<#$FTcomputers =@()
$OUSearchBase = "OU=Windows Servers,DC=ad,DC=ft,DC=com"
$OUexclusion = "Windows Servers", "ZZZ - Computers to be deleted", "ZZZ - GPO Testing"

$ous = Get-ADOrganizationalUnit -SearchBase $OUSearchBase -SearchScope Subtree -Filter *

ForEach($ou in $ous){

  if ($OUexclusion -NotContains "$($ou.name)"){
    write-host "$ou.name in loop"

    $FTcomputers += $(Get-ADComputer -filter * -SearchBase $ou.DistinguishedName -properties * )|
    Select @{n='ou';e={$ou.name}}, *
  }
}

$FTcomputers | Export-Clixml -Path C:\Amar\FTServers.xml

#>

$FTcomputers = import-Clixml -Path C:\Amar\FTServers.xml
$OUTPUT= $FTcomputers[0..2] | %{ 
$compname = $_.name 
$os = $_.operatingSystem
$lastlogon = [datetime]::FromFileTime($_.lastLogon)
#Write-Host "$compname "
    

    try{
    #$name = Invoke-Command -ComputerName $($_.Name) -ScriptBlock {$env:COMPUTERNAME}
    $res = Invoke-Command -ComputerName $($_.Name) -ScriptBlock {$($psversiontable.psversion).Major}
    "" | select @{name="psversion";e={$res}}, @{name ="ComputerName";e={$compname}}, @{name ="OS";e={$os}}, @{name ="LastLogon";e={$lastlogon}}
    
    }
    catch{
    "" | select @{name="psversion";e={"N/A"}}, @{name ="ComputerName";e={$compname}}, @{name ="OS";e={$os}}, @{name ="LastLogon";e={$lastlogon}}
    }

}
 $output | select computername, psversion, os, LastLogon,  @{name="ping";e={$(Test-Connection ($_.computername) -count 1 -quiet)}} | Export-csv -NoTypeInformation .\Computers.csv


 



