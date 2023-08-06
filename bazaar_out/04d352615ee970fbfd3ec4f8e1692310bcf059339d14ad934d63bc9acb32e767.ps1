@echo off
setlocal enableDelayedExpansion
set buildid=6.10
set filepath=C:\Users\Mitchell\Documents

SET FLAG="-"
SET BUILD_NUMBER=0
SET REV_NUMBER=0
SET VARIANT=""

GOTO :processargs

:processargs
SET ARG=%1
IF DEFINED ARG (
	IF "%ARG%"=="-w" SET FLAG="-w"
	IF "%ARG%"=="-l" SET FLAG="-l"
	IF "%ARG%"=="-a" SET FLAG="-a"
	echo "%ARG%" | find "." > nul
	if !ERRORLEVEL! == 0 (
		FOR /f "tokens=1,2 delims=." %%a in ("%ARG%") DO (
			SET BUILD_NUMBER=%%a
			SET REV_NUMBER=%%b
		)
	)
	SHIFT
	GOTO processargs
)

IF %BUILD_NUMBER%==0 (
	ECHO NO BUILD NUMBER FOUND
	EXIT /B 1
)

IF "%FLAG%"=="-" (
	ECHO NO BUILD FLAG FOUND
	EXIT /B 1
)

IF %FLAG%=="-w" GOTO :windows
IF %FLAG%=="-l" GOTO :linux
IF %FLAG%=="-a" GOTO :android

GOTO :EOF

:windows
echo Windows flag
SET VARIANT=windows_ots
CALL :create_directories
if not exist "%filepath%\windows-test.zip" (
	ECHO DOWNLOADING BUILD %BUILD_NUMBER%.%REV_NUMBER%...
	powershell -Command "(new-object System.Net.WebClient).DownloadFile('example.url/windows-test.zip','%filepath%\windows-test.zip')"
	ECHO EXTRACTING...
	powershell Expand-Archive %filepath%\windows-test.zip -DestinationPath %filepath%\
	del %filepath%\windows-test.zip
)
ECHO DONE ----------- BUILD CAN BE FOUND AT %filepath%
EXIT /B 0

:linux
echo Linux flag
SET VARIANT=linux_ots
CALL :create_directories
if not exist "%filepath%\linux-test.zip" (
	ECHO DOWNLOADING BUILD %BUILD_NUMBER%.%REV_NUMBER%...
	powershell -Command "(new-object System.Net.WebClient).DownloadFile('example.url\linux-test.zip','%filepath%\linux-test.sh')"
)
ECHO DONE ----------- BUILD CAN BE FOUND AT %filepath%
EXIT /B 0

:android
echo Android flag
SET VARIANT=android
CALL :create_directories
FOR /F "skip=1"  %%x IN ('adb devices') DO (
	echo 'Running on %%x'
	adb -s %%x shell pm list packages | findstr package
	if !ERRORLEVEL! == 0 (
		adb -s %%x uninstall package
	)
	adb -s %%x shell getprop ro.product.cpu.abi | findstr "arm"
	if !ERRORLEVEL! == 0 (
		if not exist "%filepath%\linux-test-arm.apk" (
			powershell -Command "(new-object System.Net.WebClient).DownloadFile('example.url\linux-test-arm.apk','%filepath%\linux-test-arm.apk')"
		)
		adb -s %%x install -g %filepath%\linux-test-arm.apk
	) else (
		if not exist "%filepath%\linux-test-x86.apk" (
			powershell -Command "(new-object System.Net.WebClient).DownloadFile('example.url\linux-test-x86.apk','%filepath%\linux-test-x86.apk')"
		)
		adb -s %%x install %filepath%\linux-test-x86.apk
	)
)
EXIT /B 0


:create_directories
if not exist D:\ (
	if not exist "%filepath%\builds" (
		mkdir %filepath%\builds
	)
	if not exist "%filepath%\builds\%VARIANT%" (
		mkdir %filepath%\builds\%VARIANT%
	)
	if not exist "%filepath%\builds\%VARIANT%\%BUILD_NUMBER%.%REV_NUMBER%" (
		mkdir %filepath%\builds\%VARIANT%\%BUILD_NUMBER%.%REV_NUMBER%
	)
	SET filepath=%filepath%\builds\%VARIANT%\%BUILD_NUMBER%.%REV_NUMBER%
) else (
	ECHO DOWNLOADING ONTO USB DRIVE...
	if not exist "D:\%BUILD_NUMBER%.%REV_NUMBER%" (
		ECHO CREATING BUILD DIRECTORY ON USB
		mkdir D:\%BUILD_NUMBER%.%REV_NUMBER%
	)
	set filepath=D:\%BUILD_NUMBER%.%REV_NUMBER%
)
GOTO :EOF
