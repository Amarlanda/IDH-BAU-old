$currentRegion = "eu-west-1"

$newami =@()


"InfraDEV", "InfraProd" | foreach-object {
  $currentkey = $_

    $EC2status =@{}
    $EC2imageshash =@{}

#used for windows only
 $images = (Get-EC2Image -Filter @{"Name"="platform";"Value"="windows"} -Region $currentRegion -ProfileName $currentkey)

#used for all image types

  $images | foreach-object {
      $EC2imageshash.Add($($_.imageid), $_.name)
    }

  $instances= Get-EC2Instance -Region $currentRegion -ProfileName $currentkey

  Foreach ($instance in $instances)
  {
      $instance = $instance | Select *,
       @{n='enviorment';e={"AWS - $currentkey"}},
       @{n='OS';e={$($EC2imageshash.get_item($_.instances.imageid))}},
       @{n='obj';e={$_}}

      For ($i=0; $i -lt $($instance.instances.tags).count; $i++) {
          $instance = $instance | Select *, @{n="$($instance.instances.tags[$i].key)";e={"$($instance.instances.tags[$i].value)"}}
      }

      $newami += $instance
  }

}

#function Combine-AWSandAD() {

$ftservers = Import-Clixml -Path C:\Amar\ADObjects.xml

## need to add error checking for mulitple VMs with the same name
$FtserversANDaws =@()

    Foreach($AWSwindowsServer in $( $newami | ? { $_.OS -ne $null })){
        #write-host "loop 1"
        ForEach($ADserver in $ftservers){
           # write-host "loop 2"
            $serverProperties = $($ADserver.PSObject.Properties)

            if ($($AWSwindowsServer.name) -like "$($ADserver.name)"){
            write-host "$($AWSwindowsServer.name)+ $($ADserver.name)"
               for ($i = 0; $i -lt $($serverProperties.count) ;$i++){
                    $AWSwindowsServer = $AWSwindowsServer | select *,
                    @{n="$($serverProperties[$i].Name)";e={$($serverProperties[$i].value)}}

               }

            $FtserversANDaws += $AWSwindowsServer
            }
        }

    }
    $FtserversANDaws

#}
