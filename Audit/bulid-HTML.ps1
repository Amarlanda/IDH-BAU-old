$fragments =@()

$a = "<style>"
$a = $a + "BODY{background-color: rgb(255, 241, 229) ;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:rgb(255, 241, 229)}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:#fff9f5}"
$a = $a + ".warn {}"
$a = $a + "</style>"

$HTML = $tempWorkingArray[1] | select ou, name, vc, vmpath | ConvertTo-HTML -head $a -body "<H2>FINANCIAL TIMES</H2>"

<#
$HTML | %{
 $bla =$_.split("<td>") | select -First 1

$_ -replace "<td>", "$bla hey"

}| Out-File C:\amar\Test.html
#>


##creating html reports with powershell
##youtube.com
## look for CSS file url
