@echo off

set services="PatrolAgent", "BGS_SDService", "BMC Distribution Client", "Patrol for Windows Operating System Monitor"

set services=%services:@=,%

for %%i in (%services%) do (
	reg query %%i
	if ERRORLEVEL 0 echo %%i exsists
	if ERRORLEVEL 1 echo %%i does not exsists

)

set regs="HKEY_LOCAL_MACHINE\SOFTWARE\BMC Software", "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BGS_SDService", "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\dsl",
 "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\patrolagent", "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PWKNTMon"


set regs=%regs:@=,%

for %%i in (%regs%) do (
	reg query %%i
	if ERRORLEVEL 0 echo %%i exsists
	if ERRORLEVEL 1 echo %%i does not exsists

)