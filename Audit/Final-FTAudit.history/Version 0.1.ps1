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

    ## need to keep properties
    
    if ($VMwareArray){
      ## is in postion 1 then x 
      $namevar = "MachineType"
      $expression = "VMware"
      $propertyName = "VI - "

    }
    
      if ($ADArray){ # AD
      ## is in postion 1 then x 
      $namevar = "MachineType"
      $expression = "VMware"
      $propertyName = "VI - "

    }
    
      if ($AWSArray){ # AWS
      ## is in postion 1 then x 
      $namevar = "MachineType"
      $expression = "VMware"
      $propertyName = "VI - "

    }
    
  

    }# end of begin
  
    process {

    $OutterSwingArray = $null           # Cleared Swing Array so it can be used to pop the inner array.  
    $OutterSwing = $OutterSwingArray     # Array could now have one element poppd out of it.

    foreach($Outter in $OutterArray){
        
        $InnerSwingArray = $null           # Cleared Swing Array so it can be used to pop the inner array.  
        $InnerArray = $InnerSwingArray     # Array could now have one element poppd out of it.

        foreach($Inner in $InnerArray){

            if (($_| Select -ExpandProperty Name) -contains "$($Outter.name)"){  #Does Outter.name - match Inner.name
                
                for ($i = 0; $i -lt $($serverProperties.count) ;$i++){
                                                                           
                    $Inner = $Inner | select *,                                 #  loop through the properties and append to the current object "
                    @{n="VI - $($serverProperties[$i].Name)";e={$($serverProperties[$i].value)}}
                    } #end of property add forloop
                                                
                } # end of if -compare Outter.name matches Inner.name
            
            $Inner = $Inner  | select *, @{name="MachineType";e={"VMware"}}
            $Allservers += $Inner
            $InnerSwingArray  = $InnerSwingArray | ? { $($_.name) -notlike $($Inner.name)}
            } #end of inner array
            

        } #end of outter array

    }# end of process Script block

}# end of function

End{

$OutterArray | %{
$CurrentObj = $_

    for ($i = 0; $i -lt $($serverProperties.count) ;$i++){
        #write-host "Adding properties $($a1.name)+ $($serverProperties[$i].Name)"

        $CurrentObj = $CurrentObj | select *,
        @{n="VI - $($serverProperties[$i].Name)";e={"N/A"}}
        }

    $CurrentObj = $CurrentObj  | select *, @{name="MachineType";e={"ADobj"}}

    $Allservers += $CurrentObj

    }

}