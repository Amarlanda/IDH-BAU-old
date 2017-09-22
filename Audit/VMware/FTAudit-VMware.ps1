$cred = get-credential

$hostdata = @()
$VMdata = @()
  "ftvce02-wvpr-d", "ftvce02-wvnj-p", "ftvce02-wviw-t", "ftvce02-wviw-p","ftvce02-wvpr-t", "ftvce02-wvpr-t" |
  % { Connect-VIServer $_ -Force -WarningAction SilentlyContinue | % {

 $hostdata += $global:DefaultVIServers | ForEach-Object {
    $VCName  = $_.Name
    $VCVersion = $_.Version
    $VCBuild = $_.Build

    get-vmhost  | select-object Name,
        @{n='Path';e={
          $Path = ""
          $Current = $_
          do {
            if ($Current.Parent) {
              $FolderName = $Current.Parent
              $Current = $Current.Parent
            } elseif ($Current.ParentFolder) {
              $FolderName = $Current.ParentFolder
              $Current = $Current.ParentFolder
            }
            if ($FolderName -notin 'Datacenters', 'host') {
              $Path = "$FolderName\$Path"
            }
          } until (-not $Current.Parent -and -not $Current.ParentFolder) "$($VCName)\$($Path.TrimEnd('\'))"
        }},
        PowerState,
        @{n='VCName';e={$VCName}},
        @{n='VCVersion';e={$VCVersion}}
      }

     $VMdata +=  $hostdata | % {
      $CurrentVMHost = $_
      write-host "trying $($_.name)"
       get-vm -location $_.name| select Name, powerstate,
            @{n='VMPath';e={"$($CurrentVMHost.path)\$($_.vmhost)"}},
            @{n='VMHostName';e={$CurrentVMhost.name}},
            @{n='VMHostPowerState';e={$CurrentVMhost.PowerState}},
            @{n='VMPowerState';e={$_.PowerState}},
            @{n='VC';e={$CurrentVMhost.VCName}},
            @{n='VersionVC';e={$CurrentVMhost.VCVersion}},
            @{n='Datastores'; e={($_.datastoreidlist | % { Get-Datastore -Id $_ } )-join ", "}}
            $hostdata
   }
   write-host "Disconnect-viserver from $($global:DefaultVIServers.name)"
   Disconnect-viserver * -confirm:$false
   $VMdata
  }

  $VMdata | Export-Csv -NoTypeInformation C:\Amar\VMHostAudit.csv
}
