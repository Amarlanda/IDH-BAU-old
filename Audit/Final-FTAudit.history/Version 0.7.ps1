function build-FTAudit{
  
  [CmdLetBinding()]
  param(
  
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.Collections.ArrayList]$BaseArray,

    #[Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.Collections.ArrayList]$VMwareArray,

    #[Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.Collections.ArrayList]$ADArray,

    #[Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.Collections.ArrayList]$AWSArray
    
  )
  
 
  begin {
    write-host "begin"
    $Allservers = New-Object System.Collections.ArrayList
    # $Allservers = New-Object System.Collections.ArrayList
    ## need to keep properties
    $OutterArray = $BaseArray
 
    if ($VMwareArray){
      ## is in postion 1 then x 
      $namevar = "MachineType"
      $expression = "VMware"
      $propertyName = "VI - "
      $serverProperties = $($VMwareArray[0].PSObject.Properties)
      $InnerArray = $VMwareArray

    }
    
    if ($ADArray){ # AD
      ## is in postion 1 then x 
      $namevar = "MachineType"
      $expression = "AD"
      $propertyName = "AD - "
      $serverProperties = $($ADArray[0].PSObject.Properties)
      $InnerArray = $ADArray

    }
    
    if ($AWSArray){ # AWS
      ## is in postion 1 then x 
      $namevar = "MachineType"
      $expression = "AWS"
      $propertyName = "AWS - "
      $serverProperties = $($AWSArray[0].PSObject.Properties)
      $InnerArray = $AWSArray

    }
  }# end of begin
  
  process {

    $OutterSwingArray = $null           # Cleared Swing Array so it can be used to pop the inner array.  
    $OutterSwing = $OutterSwingArray     # Array could now have one element poppd out of it.

    foreach($Outter in $OutterArray){
          
      $InnerSwingArray = $null           # Cleared Swing Array so it can be used to pop the inner array.  
      $InnerArray = $InnerSwingArray     # Array could now have one element poppd out of it.

      foreach($Inner in $InnerArray){

        if (($_| Select-Object -ExpandProperty Name) -contains "$($Outter.name)"){  #Does Outter.name - match Inner.name
                
          for ($i = 0; $i -lt $($serverProperties.count) ;$i++){
                                                                           
            $Inner = $Inner | Select-Object -Property *,                                 #  loop through the properties and append to the current object "
            @{n="VI - $($serverProperties[$i].Name)";e={$($serverProperties[$i].value)}}
          } #end of property add forloop
                                                
        } # end of if -compare Outter.name matches Inner.name
            
        $Inner = $Inner  | Select-Object -Property *, @{name="MachineType";e={$expression}}
        $Allservers += $Inner
        $InnerSwingArray  = $InnerSwingArray | ? { $($_.name) -notlike $($Inner.name)}
      } #end of inner array
         
    } #end of outter array

  }# end of process Script block



  End{

    $OutterArray | ForEach-Object -Process {
      $CurrentObj = $_

      for ($i = 0; $i -lt $($serverProperties.count) ;$i++){
        #write-host "Adding properties $($a1.name)+ $($serverProperties[$i].Name)"

        $CurrentObj = $CurrentObj | Select-Object -Property *,
        @{n="VI - $($serverProperties[$i].Name)";e={"N/A"}}
      }

      $CurrentObj = $CurrentObj  | Select-Object -Property *, @{name="MachineType";e={"ADobj"}}

      $Allservers += $CurrentObj

      return $Allservers
    }

  }
}# end of function


[System.Collections.ArrayList]$Array0 = 
[System.Collections.ArrayList]$Array1 = 

$base = $(Import-Clixml -Path "C:\Amar\vmdata.xml")

build-FTAudit -BaseArray $base -VMwareArray $base