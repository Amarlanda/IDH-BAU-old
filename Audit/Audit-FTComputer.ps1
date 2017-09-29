

<#function move datatype into incomplete

switch [vmware]
switch [AD]
switch [AWS]

#>



<#function Normalise Data{

##make the normalise bomb proof

| sort name -Unique | measure-object
Sort-Object -Property @{Expression={$_.Trim()}} -Unique

}
#>


#function VMware-AWSandAD() {

[System.Collections.ArrayList]$inputSearchObject = Import-Clixml -Path "C:\Amar Remote Vi ftvc02-wvnj-p\vmdata.xml"
[System.Collections.ArrayList]$incompleteReport = Import-Clixml -Path "C:\Amar Remote Vi ftvc02-wvnj-p\ADObjects.xml"

#$inputSearchObject | measure-object
$num = $($incompleteReport | measure-object)

## need to add error checking for mulitple VMs with the same name
$tempWorkingArray =@()

    Foreach($newServerObj in $incompleteReport){ #adobj
        #write-host "loop 1"
        ForEach($currentReportServer in $inputSearchObject){ #vmware object
           # write-host "loop 2"
            $serverProperties = $($currentReportServer.PSObject.Properties)

            if ($($newServerObj.name) -like "$($currentReportServer.name)"){

$incompleteReport.remove($newServerObj) ## NEEDE TO CHECK

            write-host "$($newServerObj.name)+ $($currentReportServer.name)"
               for ($i = 0; $i -lt $($serverProperties.count) ;$i++){
                    $newServerObj = $newServerObj | select *,
                    @{n="$($serverProperties[$i].Name)";e={$($serverProperties[$i].value)}}


               } #end of server properties add forloop
          $newServerObj = $newServerObj | select *, @{n='HostType';e={"VMware Inc"}}
            $incompleteReport.remove($newServerObj)
            $tempWorkingArray += $newServerObj
          } #end of if for matching servername with current report server name


          else {
             # write-host "hasnt found match for $($newServerObj.name)"
              #$tempWorkingArray += $newServerObj
              }

            }
        }

<# how to remove item
PS C:\Windows\system32> $incompleteReport.contains(($incompleteReport | ?{$_.name -like "*FTAPP065-WVIR-P*"}))
True
PS C:\Windows\system32> $incompleteReport.remove(($incompleteReport | ?{$_.name -like "*FTAPP065-WVIR-P*"}))
PS C:\Windows\system32> $incompleteReport.contains(($incompleteReport | ?{$_.name -like "*FTAPP065-WVIR-P*"}))
False


#}

#$VMdata
