function Audit-FTServerEstate {
  # .SYNOPSIS
  #   Combines all server data from the VMware Estate, AWS Estate and Windows diretory services
  # .DESCRIPTION
  #  the normlises the data using two annoynoymous arrays and a switch statement to handle the varaibles.
  #
  #   This CmdLet assumes the user is authenticated.
  # .PARAMETER ComputerName
  #   The computer to execute against. By default the local computer is used.
  # .PARAMETER StartRemoteRegistry
  #   The script should attempt to start the remote registry service if it is not already running. This parameter will only take effect if the service is not disabled.
  # .PARAMETER IncludeLoadedUserHives
  #   Some software packages, such as DropBox install into a users profile rather than into shared areas. Get-InstalledSoftware can increase the search to include each loaded user hive.
  #
  #   If a registry hive is not loaded it cannot be searched, this is a limitation of this search style.
  # .PARAMETER IncludeBlankNames
  #   By default Get-InstalledSoftware will suppress the display of entries with minimal information. If no DisplayName is set it will be hidden from view. This behaviour may be changed using this parameter.
  # .PARAMETER DebugConnection
  #   By default error messages are suppressed. A large number of errors may be returned by a single device because of the granular nature of registry permissions. This parameter allows the displays of all caught exceptions for debugging purposes.
  # .INPUTS
  #   System.String
  # .OUTPUTS
  #   FTCodeBase.CMDB.SoftwareItem
  # .EXAMPLE
  #   Get-InstalledSoftware
  #
  #   Get the list of installed applications from the local computer.
  # .EXAMPLE
  #   Get-InstalledSoftware -IncludeLoadedUserHives
  #
  #   Get the list of installed applications from the local computer, including each loaded user hive.
  # .EXAMPLE
  #   Get-InstalledSoftware -ComputerName None -DebugConnection
  #
  #   Display all error messages thrown when attempting to audit the specified computer.
  # .EXAMPLE
  #   Get-InstalledSoftware -IncludeBlankNames
  #
  #   Display all results, including those with very limited information.
  # .NOTES
  #   Author: Amar Landa
  #   Team:   Infrastructure and Data Hosting
  #
  #   Change log:

  [CmdLetBinding()]
  param(

)
[System.Collections.ArrayList]$Array0 = Import-Clixml -Path "C:\Amar\vmdata.xml"
[System.Collections.ArrayList]$Array3 = Import-Clixml -Path "C:\Amar\ADObjects.xml"


#$SwingArray1 = New-Object -TypeName System.Collections.ArrayList
$Allservers = New-Object -TypeName System.Collections.ArrayList
$Array1 = New-Object -TypeName System.Collections.ArrayList

$serverproperties = $($Array0[0].PSObject.Properties)




$Array3| % {
$array1 += $_ }


$Array0 | %{
$a0 = $_
#write-host "checking element $($a0.name) from array0"  -ForegroundColor Green


$SwingArray1 = New-Object -TypeName System.Collections.ArrayList
$Array1 | % {
#write-host "repopulated SwingArray1 with $($_.name) from array1"  -ForegroundColor Black
$SwingArray1 += $_
}

    $SwingArray1 | % {
        $a1 = $_
        #write-host "looping through swing array and comparing $($a1.name) from array1 with $($a.name) from array0 "

        if (($_| Select -ExpandProperty Name) -contains "$($a0.name)"){
        # write-host "matched $($a1.name) with $($a0.name)" -ForegroundColor Red

               #adding properties
              # write-host "Adding properties $($a0.name)+ $($a1.name)"
               for ($i = 0; $i -lt $($serverProperties.count) ;$i++){
                  #  write-host "Adding properties $($a1.name)+ $($serverProperties[$i].Name)"

                    $a1 = $a1 | select *,
                    @{n="VI - $($serverProperties[$i].Name)";e={$($serverProperties[$i].value)}}
                }
             $a1 = $a1  | select *, @{name="MachineType";e={"VMware"}}
             $Allservers += $a1
             $array1  = $array1 | ? { $($_.name) -notlike $($a1.name)}
            # write-host "removing $($a0.name) from array1"

        }else{
      #  write-host "didnt work $($a1.name) does not match $($a.name) " -ForegroundColor Cyan
        }


    }
}

$Array1 | %{
$a1 = $_

  for ($i = 0; $i -lt $($serverProperties.count) ;$i++){
                    #write-host "Adding properties $($a1.name)+ $($serverProperties[$i].Name)"

                    $a1 = $a1 | select *,
                    @{n="VI - $($serverProperties[$i].Name)";e={"N/A"}}
                }
                $a1 = $a1  | select *, @{name="MachineType";e={"ADobj"}}

$Allservers += $a1

}

$Allservers
