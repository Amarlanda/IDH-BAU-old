function build-FTAudit{
  
  [CmdLetBinding()]
  param(
  
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    $BaseArray,

    #[Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    $VMwareArray,

    #[Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    $ADArray,

    #[Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    $AWSArray
    
  )
  
 
  begin {
    write-host "begin"
    $Allservers = New-Object System.Collections.ArrayList
    # $Allservers = New-Object System.Collections.ArrayList
    ## need to keep properties
        $OutterSwingArray = $BaseArray
 
    if ($VMwareArray){
      ## is in postion 1 then x 
      $namevar = "MachineType"
      $expression = "VMware"
      $propertyName = "VI - "
      $serverProperties = $($VMwareArray[0].PSObject.Properties)
      $InnerSwingArray = $VMwareArray

    }
    
    if ($ADArray){ # AD
      ## is in postion 1 then x 
      $namevar = "MachineType"
      $expression = "AD"
      $propertyName = "AD - "
      $serverProperties = $($ADArray[0].PSObject.Properties)
      $InnerSwingArray = $ADArray

    }
    
    if ($AWSArray){ # AWS
      ## is in postion 1 then x 
      $namevar = "MachineType"
      $expression = "AWS"
      $propertyName = "AWS - "
      $serverProperties = $($AWSArray[0].PSObject.Properties)
      $InnerSwingArray = $AWSArray

    }
  }# end of begin
  
  process {

     
    $OutterArray = $OutterSwingArray     # Array could now have one element poppd out of it.

    foreach($Outter in $OutterArray){
          
      #$InnerSwingArray = $null           # Cleared Swing Array so it can be used to pop the inner array.  
      $InnerArray = $InnerSwingArray     # Array could now have one element poppd out of it.


      foreach($Inner in $InnerArray){

        if ($($Inner.Name) -contains $($Outter.name)){  #Does Outter.name - match Inner.name
                
          for ($i = 0; $i -lt $($serverProperties.count) ;$i++){
                                                                           
            $Inner = $Inner | Select-Object -Property *,                                 #  loop through the properties and append to the current object "
            @{n="VI - $($serverProperties[$i].Name)";e={$($serverProperties[$i].value)}}
          } #end of property add forloop
        
          $InnerSwingArray  = $InnerSwingArray | Where-Object { $($_.name) -notlike $($Inner.name)}
          $OutterSwingArray  = $OutterSwingArray | Where-Object { $($_.name) -notlike $($Inner.name)} 
          $Inner = $Inner  | Select-Object -Property *, @{name="MachineType";e={$expression}}
          $Allservers += $Inner  
          { Break }                                       
        } # end of if -compare Outter.name matches Inner.name
            
                
      } #end of inner array
      
    } #end of outter array

  }# end of process Script block



  End{

    $OutterArray | ForEach-Object {
      $CurrentObj = $_

      for ($i = 0; $i -lt $($serverProperties.count) ;$i++)
      {
        #write-host "Adding properties $($a1.name)+ $($serverProperties[$i].Name)"

        $CurrentObj = $CurrentObj | Select-Object -Property *,
        @{n="VI - $($serverProperties[$i].Name)";e={"N/A"}}
      }

      $CurrentObj = $CurrentObj  | Select-Object -Property *, @{name="MachineType";e={"ADobj"}}

      $Allservers += $CurrentObj
      
      

      #return $Allservers
    }
    return $Allservers 
  }
  
  
} #end of function


[System.Collections.ArrayList]$Array0 = 
[System.Collections.ArrayList]$Array1 = 

$base = $(Import-Clixml -Path "C:\Amar\Modified_VMwareServers.xml")
$bla = $(Import-Clixml -Path "C:\Amar\Modified     bjects.xml")

build-FTAudit -BaseArray $bla[0..2] -VMwareArray $base[0..2] | select machinetype, name

