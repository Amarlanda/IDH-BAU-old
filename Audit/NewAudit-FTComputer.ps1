[System.Collections.ArrayList]$Array0 = Import-Clixml -Path "C:\Amar\vmdata.xml"
[System.Collections.ArrayList]$Array3 = Import-Clixml -Path "C:\Amar\ADObjects.xml"
#$SwingArray1 = New-Object -TypeName System.Collections.ArrayList
$SwingArray0 = New-Object -TypeName System.Collections.ArrayList
$Array1 = New-Object -TypeName System.Collections.ArrayList



$Array3[276..277] | % {
$array1 += $_ }


$Array0[0..1] | %{
$a0 = $_
write-host "checking element $($a0.name) from array0"  -ForegroundColor Green


$SwingArray1 = New-Object -TypeName System.Collections.ArrayList
$Array1 | % { 
write-host "repopulated SwingArray1 with $($_.name) from array1"  -ForegroundColor Black
$SwingArray1 += $_
}

    $SwingArray1 | % {
        $a1 = $_
        write-host "looping through swing array and comparing $($a1.name) from array1 with $($a.name) from array0 "

        if (($_| Select -ExpandProperty Name) -contains "$($a0.name)"){
         write-host "matched $($a1.name) with $($a0.name)" -ForegroundColor Red

             $array1  = $array1 | ? { $($_.name) -notlike $($a1.name)}
             write-host "removing $($a0.name) from array1"

        }else{
        write-host "didnt work $($a1.name) does not match $($a.name) " -ForegroundColor Cyan
        }


    }
}
