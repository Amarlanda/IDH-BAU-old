#Removal of Registry keys 

echo "removing keys HKEY_LOCAL_MACHINE\SOFTWARE\BMC Software"
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\BMC Software" /f

echo "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BGS_SDService"
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BGS_SDService" /f

echo "removing keys HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\dsl"
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\dsl" /f

echo "removing keys HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\patrolagent"
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\patrolagent" /f

echo "removing keys HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PWKNTMon"
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PWKNTMon" /f


set services="HKEY_LOCAL_MACHINE\SOFTWARE\BMC Software", 
"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BGS_SDService",
  "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\dsl",
 "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\patrolagent",
 "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PWKNTMon"


set services=%services:@=,%

for %%i in (%services%) do (
	reg query %%i
	if ERRORLEVEL 0 echo %%i exsists
	if ERRORLEVEL 1 echo %%i does not exsists

)