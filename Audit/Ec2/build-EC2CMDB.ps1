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

$windowsAMIs = $newami | ? { $_.OS -ne $null } ## get null OS i.e for non windows

$FtserversANDaws = @()

$windowsAMIs | % {
    $currentobj = $_

    $Ftservers | %{

    write-host "$($_.name) -like $($currentobj.name)"
        ?($($_.name) -like "*$($currentobj.name)*"){
            Write-host "found $_.name $currentobj.name"
            $FtserversANDaws += $_ | select *
        }
    }

}
