################
<#
Build in report for networks team barry


$bla =@()

$OUSearchBase = "OU=Users,OU=OSB,OU=EMEA,DC=ad,DC=ft,DC=com"
$OUexclusion = "Windows Servers", "ZZZ - Computers to be deleted", "ZZZ - GPO Testing"

$ous = Get-ADOrganizationalUnit -SearchBase $OUSearchBase -SearchScope Subtree -Filter *| %{

    if ($OUexclusion -NotContains "$($_.name)"){
        $bla +="$_" | % {
        $_ -replace "OU=", ""}| % {
        $_ -replace "DC=", ""} |% {
        $_ -replace "FT=", ""}

    }
}
$bla

  <#
    #Select @{n='ou';e={$ou.name}}, *
  }
  }



  $_.distinguishedName | % {
  $_ -replace "OU=", ""}| % {
  $_ -replace "DC=", ""} |% {
  $_ -replace "FT=", ""}


  #>

#>

##AD - Search windows OUs and append OU shortname to AD Computer object
#################################################################

$FTcomputers =@()
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

##Search windows OUs and append OU shortname to AD Computer object
#################################################################

$FTServers =@()
$FTcomputers | % {
  $FTServersft
  $i++
  $currentObj = $_
 try
    {
        $errorActionPreference = "Stop"
        $result = Invoke-Command -ComputerName $($_.Name) { 1 }
        $obj= $_ | select *, @{n='PSremoting';e={"True"}}
        $FTServers += $obj
        "success $($_.name)!"
        "$i"

    }
  catch
    {
        $ErrorValue = $_
        $obj= $currentObj | select *, @{n='PSremoting';e={"False"}}, @{n='PSremotingErrorObj';e={"$ErrorValue"}}
        $FTServers += $obj
        "Failed $($_.name)!"
        "$i"
    }
}

$FTServers | Export-Clixml -path c:\amar\computer.xml

##
#Test-connection
##

####
##is ADObject dead ?


##
#lastlogins
