opt("WinTitleMatchMode",3)
$workingdirectory = "C:\Program Files\Andy"
$tempDir=@TempDir&"\BetaLeaf Software\AndyRoot\"
DirCreate($tempDir)
FileInstall("adb.exe",$tempDir&"adb.exe",1)
FileInstall("AdbWinApi.dll",$tempDir&"AdbWinApi.dll",1)
FileInstall("AdbWinUsbApi.dll",$tempDir&"AdbWinUsbApi.dll",1)
FileInstall("fastboot.exe",$tempDir&"fastboot.exe",1)
FileInstall("rootcheck.apk",$tempDir&"rootcheck.apk",1)
FileInstall("su",$tempDir&"su",1)
FileInstall("Superuser.apk",$tempDir&"Superuser.apk",1)
FileInstall("AndyRoot.bat",$tempDir&"AndyRoot.bat",1)
If FileExists("C:\Program Files\Andy\Andy.exe") = 0 Then
	$ret = MsgBox(64 + 4, "AndyRoot", "Andy is not installed on this computer. Shall I install it for you?")
	Select
		Case $ret = 6
			TrayTip("AndyRoot", "Please wait while we install Andy for you. You may continue using your computer.", 10)
			$ret = InetGet("http://downloads.andyroid.net/installer/v46/Andy_46.2_207_x64bit.exe", $tempDir&"AndyIns.exe", 1)
			Select
				Case $ret = 0
					InputBox("AndyRoot", "An error occured during the download and cannot continue. Please go to the following website to install Andy.", "http://www.andyroid.net/")
					Exit
				Case $ret < 5 * 1000 * 1024
					InputBox("AndyRoot", "An error occured during the download and cannot continue. Please go to the following website to install Andy.", "http://www.andyroid.net/")
					Exit
			EndSelect
			TrayTip("AndyRoot", "Download Completed. Installing...", 10)
			ShellExecuteWait($tempDir&"AndyIns.exe","/?")
			ProcessWait("AndyConsole.exe")
			WinWait("Andy")
			TrayTip("AndyRoot", "Installation Completed.", 10)
			sleep(5000)
		Case Else
			MsgBox(16, "AndyRoot", "Cannot continue without Andy installed. Exiting...")
			Exit
	EndSelect
EndIf
;CloseAndy();Old method and no longer needed
AndyRoot()
Func CloseAndy()
	TrayTip("AndyRoot","Closing Andy so we can root.",10)
	$timer=TimerInit()
do
	ProcessClose("AndyConsole.exe")
	if TimerDiff($timer) > (60*1000) then msgbox(16,"AndyRoot","Unable to close the following processes within 60 seconds:" &@CRLF&@CRLF&"adb.exe"&@CRLF&"Andy.exe"&@CRLF&"AndyADB.exe"&@CRLF&"AndyConsole.exe"&@CRLF&"AndyDND.exe"&@CRLF&"HandyAndy.exe"&@CRLF&@CRLF&"Please terminate these processes to continue.")
until ProcessExists("AndyConsole.exe") = 0
do
	ProcessClose("adb.exe")
	if TimerDiff($timer) > (60*1000) then msgbox(16,"AndyRoot","Unable to close the following processes within 60 seconds:" &@CRLF&@CRLF&"adb.exe"&@CRLF&"Andy.exe"&@CRLF&"AndyADB.exe"&@CRLF&"AndyConsole.exe"&@CRLF&"AndyDND.exe"&@CRLF&"HandyAndy.exe"&@CRLF&@CRLF&"Please terminate these processes to continue.")
until ProcessExists("adb.exe") = 0
do
	ProcessClose("AndyADB.exe")
	if TimerDiff($timer) > (60*1000) then msgbox(16,"AndyRoot","Unable to close the following processes within 60 seconds:" &@CRLF&@CRLF&"adb.exe"&@CRLF&"Andy.exe"&@CRLF&"AndyADB.exe"&@CRLF&"AndyConsole.exe"&@CRLF&"AndyDND.exe"&@CRLF&"HandyAndy.exe"&@CRLF&@CRLF&"Please terminate these processes to continue.")
until ProcessExists("AndyADB.exe") = 0
do
	ProcessClose("AndyDnD.exe")
	if TimerDiff($timer) > (60*1000) then msgbox(16,"AndyRoot","Unable to close the following processes within 60 seconds:" &@CRLF&@CRLF&"adb.exe"&@CRLF&"Andy.exe"&@CRLF&"AndyADB.exe"&@CRLF&"AndyConsole.exe"&@CRLF&"AndyDND.exe"&@CRLF&"HandyAndy.exe"&@CRLF&@CRLF&"Please terminate these processes to continue.")
until ProcessExists("AndyDnD.exe") = 0
do
	ProcessClose("HandyAndy.exe")
	if TimerDiff($timer) > (60*1000) then msgbox(16,"AndyRoot","Unable to close the following processes within 60 seconds:" &@CRLF&@CRLF&"adb.exe"&@CRLF&"Andy.exe"&@CRLF&"AndyADB.exe"&@CRLF&"AndyConsole.exe"&@CRLF&"AndyDND.exe"&@CRLF&"HandyAndy.exe"&@CRLF&@CRLF&"Please terminate these processes to continue.")
until ProcessExists("HandyAndy.exe") = 0
do
	ProcessClose("Andy.exe")
	if TimerDiff($timer) > (60*1000) then msgbox(16,"AndyRoot","Unable to close the following processes within 60 seconds:" &@CRLF&@CRLF&"adb.exe"&@CRLF&"Andy.exe"&@CRLF&"AndyADB.exe"&@CRLF&"AndyConsole.exe"&@CRLF&"AndyDND.exe"&@CRLF&"HandyAndy.exe"&@CRLF&@CRLF&"Please terminate these processes to continue.")
until ProcessExists("Andy.exe") = 0
EndFunc
func AndyRoot()
	If ProcessExists("AndyConsole.exe") = 0 OR ProcessExists("AndyADB.exe") = 0 Then TrayTip("AndyRoot","Starting Andy. This can take a while.",10)
	if ProcessExists("AndyConsole.exe") = 0 Then 
		ShellExecute("Andy.exe",'',$workingdirectory)
		do
			Sleep(500)
		Until WinExists("Andy")
		Sleep(5000)
	EndIf
	if ProcessExists("AndyADB.exe") = 0 Then 
		ShellExecute("AndyADB.exe","",$workingdirectory)
		sleep(5000)
	EndIf
	$IP=IniRead(@AppDataDir&"\Andy\HandyAndy\HandyAndy.ini","Current","ipaddr","error")
	TrayTip("AndyRoot","Rooting...",10)
	ShellExecuteWait($tempDir&"adb.exe","connect "&$IP,$tempDir)
	sleep(5000)
	ShellExecuteWait("AndyRoot.bat","",$tempDir)
	MsgBox(0,"Andy","Please run Root Checker Basic in Andy and click Verify Root. If you were asked for root access, then root succeeded. If root did not succeed, rerun this app.")
EndFunc