function rename-arry {
     $returnArry = @() 
     $Arrray = $args[0]
     $propertyName =$args[2]
     $expression = $args[1]
     $serverProperties = $($Arrray[0].PSObject.Properties)

     $Arrray | ForEach-Object -process {
       $currentitem = $_

       for ($i = 0; $i -lt $($serverProperties.count) ;$i++){
                                                                                       
         $currentitem |add-member -membertype noteproperty -Name "$propertyName $($serverProperties[$i].Name)" -value "$($serverProperties[$i].value)" -Force
       } 
      
       $currentitem = $currentitem | Select-Object -Property $propertyName*, name,
       @{n="MachineType";e={$expression}}
       #$currentitem = $currentitem | Where-Object { $($_.name) -notlike $($Inner.name)} 
       
       
       $returnArry += $currentitem # end of for
       $serverProperties = $($returnArry[0].PSObject.Properties)
  
     }#end of args
     return $returnArry, $expression, $serverProperties
   }
  
   
   function build-FTAudit{
  
     [CmdLetBinding()]
     param(
  
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
  
       ##GLOBAL 
       $script:Allservers = New-Object -TypeName System.Collections.ArrayList     # Declare $Allservers = New-Object System.Collections.ArrayList
   
       # need to populate the swing arrays     

       if ($VMwareArray){
         $array1 = rename-arry $VMwareArray "VMware" "VI - "
       }
       if ($ADArray){
         $array0 = rename-arry $ADArray "ADobj" "AD - "
       } 
       if ($AWSArray){
          $array1 = rename-arry $ADArray  "AWS" "AWS - "
       }
     } 

     process {
     
       $OutterSwingArray = $array0[0]
       $outterExpression = $array0[1]
       $outterServerProperties = $array0[2]
       $innerSwingArray = $array1[0]
       $innerExpression = $array1[1]
       $innerServerProperties = $array1[2]
        
       $OutterArray = $OutterSwingArray     # Array could now have one element poppd out of it.

       foreach($Outter in $OutterArray){
          
         #$InnerSwingArray = $null           # Cleared Swing Array so it can be used to pop the inner array.  
         $InnerArray = $InnerSwingArray     # Array could now have one element poppd out of it.


         :inner  foreach($Inner in $InnerArray){

           if ($($Inner.Name) -contains $($Outter.name)){  #Does Outter.name - match Inner.name
                
             for ($i = 0; $i -lt $($outterServerProperties.count) ;$i++){
                                                                           
               # $Inner = $Inner | Select-Object -Property *,                                 #  loop through the properties and append to the current object "
               # @{n="$($outterServerProperties[$i].Name)";e={$($outterServerProperties[$i].value)}}
               
               $Inner | add-member -membertype noteproperty -Name $($outterServerProperties[$i].Name) -value $($outterServerProperties[$i].value) -force   
             } #end of property add forloop
        
             $InnerSwingArray  = $InnerSwingArray | Where-Object { $($_.name) -notlike $($Inner.name)}
             $OutterSwingArray  = $OutterSwingArray | Where-Object { $($_.name) -notlike $($Inner.name)} 
             $Inner | add-member -membertype noteproperty -Name "MachineType" -value $innerExpression -force 
          
   
             $Allservers += $Inner  
             break inner                                     
           } # end of if -compare Outter.name matches Inner.name
            
           $InnerArray = $InnerSwingArray        
         } #end of inner array
      
    
       } #end of outter array
       $Allservers

     }# end of process $Allserversk
     
     
     End{


       $outterSwingArray | ForEach-Object {
         $outterServerProperties = $serverProperties
         $CurrentObj = $_

         for ($i = 0; $i -lt $($serverProperties.count) ;$i++){

           #write-host "Adding properties $($a1.name)+ $($serverProperties[$i].Name)"

           $CurrentObj = $CurrentObj | Select-Object -Property *,
           @{n="$($serverProperties[$i].Name)";e={"N/A"}}
         }

         $CurrentObj = $CurrentObj   | add-member -membertype noteproperty -Name "MachineType" -value $outterExpression -force 

         $Allservers += $CurrentObj
         $Allservers
       }
       $InnerSwingArray | ForEach-Object {
         $innerServerProperties = $serverProperties
         $CurrentObj = $_

         for ($i = 0; $i -lt $($serverProperties.count) ;$i++){
           #write-host "Adding properties $($a1.name)+ $($serverProperties[$i].Name)"

           $CurrentObj = $CurrentObj | Select-Object -Property *,
           @{n="$($serverProperties[$i].Name)";e={"N/A"}}
         }

         $CurrentObj = $CurrentObj | add-member -membertype noteproperty -Name "MachineType" -value $innerExpression -force 
         $Allservers += $CurrentObj  
            
       }

       return $Allservers 
       
     } #end of end 
     #end of function
   }

   Clear-Host

   $base = $(Import-Clixml -Path "C:\Amar\Modified_vmdata.xml")
   $bla = $(Import-Clixml -Path "C:\Amar\Modified_ADObjects.xml")


   build-FTAudit -ADArray $bla[0..2] -VMwareArray $base[0..2] 


