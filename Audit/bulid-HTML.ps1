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
$FTServers | ? { $_.psremoting -eq $true} | % {

$one = Import-Clixml -Path "C:\Amar\Computers\$($_.name).xml"|
ConvertTo-HTML -Fragment

$two = Import-Clixml -Path "C:\Amar\Computers\$($_.name)-Installedsoftware.xml"|
ConvertTo-HTML -Fragment


$html = ConvertTo-HTML -head $a -Body "<h1>FINANCIAL TIMES</h1><h3>General</h3> $one <h3>Installed Software</h3> $two" -Title "Server Stats"

$html = $html -replace "\<table\>",'<table cellpadding="10">'

$html = $html -replace '(?m)\s+$', "`r`n<BR>"

$html| Out-File "C:\Amar\Computers\$($_.name)-status.html"

}
#>

<#
    $html = $HTML | %{
    $bla =$_.split("<td>") | select -First 1

    $_ -replace "<td>", "$bla hey"

}#>

$HTML | Out-File C:\backup\codebase\IDH-BAU\Audit\HTML\Testing.html


##creating html reports with powershell
##youtube.com
## look for CSS file url
