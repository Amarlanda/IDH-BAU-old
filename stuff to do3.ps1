function Compare-element
{
    [CmdletBinding()]
    Param
    (
        # Param2 help description
        [switch]
        $Matched,
        
        # Param2 help description
        [switch]
        $NotMatched,
        
        $inputElement= $outter, 
        
        $compareElement = $inner,
        $inputArrayServerProperties=$outterServerProperties, 
        
        $compareArrayServerProperties,
        $inputArray = $OutterSwingArray
        
    )
        
    Begin{
     
      if (-not($compareArrayServerProperties)){
        $compareArrayServerProperties = $($compareArray[0].PSObject.Properties)
      }
    }
       
    Process{

     if ($($inputElement.Name) -contains $($compareElement.name)){  #Does Outter.name - match Inner.name
     
 
        for ($i = 0; $i -lt $($inputArrayServerProperties.count) ;$i++){
                                                                          
          $compareElement | add-member -membertype noteproperty -Name $($inputArrayServerProperties[$i].Name) -value $($inputArrayServerProperties[$i].value) -force   
        } #end of property add forloop
        
      }elseif($NotMatched){

       $inputArray | ForEach-Object {
         $CurrentObj = $_

         for ($i = 0; $i -lt $($serverProperties.count) ;$i++){

           #write-host "Adding properties $($a1.name)+ $($serverProperties[$i].Name)"

           $CurrentObj = $CurrentObj | Select-Object -Property *,
           @{n="$($serverProperties[$i].Name)";e={"N/A"}}
         }

         $CurrentObj = $CurrentObj   | add-member -membertype noteproperty -Name "MachineType" -value $outterExpression -force 

         $Allservers += $CurrentObj
        }#end of outterswing
      
      }#end of elsif    
    
    }#end of Process
    
    End{

    return $Allservers
    
    }
    
}
