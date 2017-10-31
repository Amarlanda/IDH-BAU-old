<#$FTServers | ? { $_.psremoting -eq $true} | % {


  $computername = "$($_.name)"
  #>
  $os = Get-WmiObject -Class win32_operatingsystem -ComputerName $computername
  $cs = Get-WmiObject -Class win32_computersystem -ComputerName $computername
  $props = @{'computername' = $computername;
             'OSVersion' = $os.version;
             'OSBuild' = $os.buildnumber;
             'SPVersion' = $os.servicepackmajorversion;
             'Model'= $cs.model;
             'Manufacturer'= $cs.manufacturer;
             'RAM'= $cs.totalphysicalmemory / 1GB -as [int];
             'Sockets'= $cs.numberofprocessors;
             'Cores'= $cs.numberoflogicalprocessors;
             'PSversion' = $psversiontable.psversion
  }
  
  
  
  $obj = New-Object -TypeName psobject -Property $props
  Write-Output $obj


  $obj | Export-Clixml -Path "C:\backup\codebase\IDH-BAU\Audit\amar\new-$computername.xml"

  #}
