$HTMLfilepath = "C:\backup\codebase\IDH-BAU\Audit\HTML\Testing.html"

$Allservers  = Import-Clixml -Path C:\backup\codebase\IDH-BAU\Audit\amar\modified_vmdata.xml
$fragments =@()

$a = "<style>"
$a = $a + "BODY{background-color: rgb(255, 241, 229) ;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:rgb(255, 241, 229)}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:#fff9f5}"
$a = $a + ".warn {}"
$a = $a + "</style>"

$HTML = $Allservers | select  MachineType, ou, name, 'VI - VC', 'VI - VMPath' | ConvertTo-HTML -head $a -body "<H2>FINANCIAL TIMES</H2>"

$HTMLlength= $html.count 

$Allservers | % {
  $currentserver = $_
  $servername = "$($currentserver.name)"
  $hyperlink = "<a href=`"C:\backup\codebase\IDH-BAU\Audit\amar\$($currentserver.name)-status.html`"> $($currentserver.name) </a>"
  for($i=0;$i-lt$HTMLlength;$i++){
    $html[$i]  = $html[$i] -replace $servername, $hyperlink
  }
}

<#
    $html = $HTML | %{
    $bla =$_.split("<td>") | select -First 1

    $_ -replace "<td>", "$bla hey"

}#>

$HTML | Out-File C:\backup\codebase\IDH-BAU\Audit\HTML\Testing.html


##creating html reports with powershell
##youtube.com
## look for CSS file url
