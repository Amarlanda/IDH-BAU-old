$Array0[0..1] | %{                                                    ##first array
$a = $_                                                               ##
$Array1[276..277] | %
   $currentitem = $_
   if (($_| Select -ExpandProperty Name) -contains "$($a.name)"){
   $_
   }else{
   "didnt work $($_.name) "
   }

}
