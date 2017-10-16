$giturl = "https://github.com/Financial-Times/acronis-sgw-snapshots.git"

#$Acronispath = D:\scripts\bla"
$Acronispath = "C:\Amar\test"




if (-not(Test-Path $Acronispath\acronis-sgw-snapshots\flag.txt )){

 cd $Acronispath
 git clone $giturl
 New-Item -Path "$Acronispath\acronis-sgw-snapshots\flag.txt" -ItemType file
 cd "$Acronispath\acronis-sgw-snapshots"
 git add .
 git commit -m "$(Get-Date -format M.d.yyyy) automated by SLR"
 git push


}else{

 cd "$Acronispath\acronis-sgw-snapshots"
 remove-item -Path "$Acronispath\acronis-sgw-snapshots\flag.txt"
 git add .
 git commit -m "$(Get-Date -format M.d.yyyy) automated by ftmgt82-wvuk-p sheduleTask CircleCI Nightly Build"
 git push

}
