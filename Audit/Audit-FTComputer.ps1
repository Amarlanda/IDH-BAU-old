

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

$inputSearchObject = Import-Clixml -Path C:\Amar\vmdata.xml
$incompleteReport = Import-Clixml -Path C:\Amar\ADObjects.xml

$inputSearchObject | measure-object
$incompleteReport | measure-object

## need to add error checking for mulitple VMs with the same name
$tempWorkingArray =@()

    Foreach($newServerObj in $incompleteReport){ #adobj
        #write-host "loop 1"
        ForEach($currentReportServer in $inputSearchObject){ #vmware object
           # write-host "loop 2"
            $serverProperties = $($currentReportServer.PSObject.Properties)

            if ($($newServerObj.name) -like "$($currentReportServer.name)"){
            write-host "$($newServerObj.name)+ $($currentReportServer.name)"
               for ($i = 0; $i -lt $($serverProperties.count) ;$i++){
                    $newServerObj = $newServerObj | select *,
                    @{n="$($serverProperties[$i].Name)";e={$($serverProperties[$i].value)}}

               }

            $tempWorkingArray += $newServerObj
            }
        }

    } $tempWorkingArray

#}

$VMdata 
