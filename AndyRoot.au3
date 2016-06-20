#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\autoitstudioicon.ico
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Opt("WinTitleMatchMode", 3)
$workingdirectory = "C:\Program Files\Andy"
$tempDir = @TempDir & "\BetaLeaf Software\AndyRoot\"
Global $timer, $count = 0
DirCreate($tempDir)
FileInstall("adb.exe", $tempDir & "adb.exe", 1)
FileInstall("AdbWinApi.dll", $tempDir & "AdbWinApi.dll", 1)
FileInstall("AdbWinUsbApi.dll", $tempDir & "AdbWinUsbApi.dll", 1)
FileInstall("fastboot.exe", $tempDir & "fastboot.exe", 1)
FileInstall("rootcheck.apk", $tempDir & "rootcheck.apk", 1)
FileInstall("su", $tempDir & "su", 1)
FileInstall("Superuser.apk", $tempDir & "Superuser.apk", 1)
If FileExists("C:\Program Files\Andy\Andy.exe") = 0 Then
	$ret = MsgBox(64 + 4, "AndyRoot", "Andy is not installed on this computer. Shall I install it for you?")
	Select
		Case $ret = 6
			TrayTip("AndyRoot", "Please wait while we install Andy for you. You may continue using your computer.", 10)
			If @OSArch = "X64" Then
				$ret = InetGet("http://downloads.andyroid.net/installer/v46/Andy_46.2_207_x64bit.exe", $tempDir & "AndyIns.exe", 1)
			Else
				$ret = InetGet("http://downloads.andyroid.net/installer/v46/Andy_46.2_207_x86bit.exe", $tempDir & "AndyIns.exe", 1)
			EndIf
			If $ret < 5 * 1000 * 1024 Or $ret = 0 Then
				InputBox("AndyRoot", "An error occured during the download and cannot continue. Please go to the following website to install Andy.", "http://www.andyroid.net/getandy.php")
				Exit
			EndIf
			TrayTip("AndyRoot", "Download Completed. Installing...", 10)
			ShellExecuteWait($tempDir & "AndyIns.exe", "/?")
			ProcessWait("AndyConsole.exe")
			WinWait("Andy")
			TrayTip("AndyRoot", "Installation Completed.", 10)
			Sleep(5000)
		Case Else
			MsgBox(16, "AndyRoot", "Cannot continue without Andy installed. Exiting...")
			Exit
	EndSelect
EndIf
;CloseAndy();Old method and no longer needed
AndyRoot()
Func CloseAndy()
	TrayTip("AndyRoot", "Closing Andy so we can root.", 10)
	$timer = TimerInit()
	Do
		ProcessClose("AndyConsole.exe")
		If TimerDiff($timer) > (60 * 1000) Then MsgBox(16, "AndyRoot", "Unable to close the following processes within 60 seconds:" & @CRLF & @CRLF & "adb.exe" & @CRLF & "Andy.exe" & @CRLF & "AndyADB.exe" & @CRLF & "AndyConsole.exe" & @CRLF & "AndyDND.exe" & @CRLF & "HandyAndy.exe" & @CRLF & @CRLF & "Please terminate these processes to continue.")
	Until ProcessExists("AndyConsole.exe") = 0
	Do
		ProcessClose("adb.exe")
		If TimerDiff($timer) > (60 * 1000) Then MsgBox(16, "AndyRoot", "Unable to close the following processes within 60 seconds:" & @CRLF & @CRLF & "adb.exe" & @CRLF & "Andy.exe" & @CRLF & "AndyADB.exe" & @CRLF & "AndyConsole.exe" & @CRLF & "AndyDND.exe" & @CRLF & "HandyAndy.exe" & @CRLF & @CRLF & "Please terminate these processes to continue.")
	Until ProcessExists("adb.exe") = 0
	Do
		ProcessClose("AndyADB.exe")
		If TimerDiff($timer) > (60 * 1000) Then MsgBox(16, "AndyRoot", "Unable to close the following processes within 60 seconds:" & @CRLF & @CRLF & "adb.exe" & @CRLF & "Andy.exe" & @CRLF & "AndyADB.exe" & @CRLF & "AndyConsole.exe" & @CRLF & "AndyDND.exe" & @CRLF & "HandyAndy.exe" & @CRLF & @CRLF & "Please terminate these processes to continue.")
	Until ProcessExists("AndyADB.exe") = 0
	Do
		ProcessClose("AndyDnD.exe")
		If TimerDiff($timer) > (60 * 1000) Then MsgBox(16, "AndyRoot", "Unable to close the following processes within 60 seconds:" & @CRLF & @CRLF & "adb.exe" & @CRLF & "Andy.exe" & @CRLF & "AndyADB.exe" & @CRLF & "AndyConsole.exe" & @CRLF & "AndyDND.exe" & @CRLF & "HandyAndy.exe" & @CRLF & @CRLF & "Please terminate these processes to continue.")
	Until ProcessExists("AndyDnD.exe") = 0
	Do
		ProcessClose("HandyAndy.exe")
		If TimerDiff($timer) > (60 * 1000) Then MsgBox(16, "AndyRoot", "Unable to close the following processes within 60 seconds:" & @CRLF & @CRLF & "adb.exe" & @CRLF & "Andy.exe" & @CRLF & "AndyADB.exe" & @CRLF & "AndyConsole.exe" & @CRLF & "AndyDND.exe" & @CRLF & "HandyAndy.exe" & @CRLF & @CRLF & "Please terminate these processes to continue.")
	Until ProcessExists("HandyAndy.exe") = 0
	Do
		ProcessClose("Andy.exe")
		If TimerDiff($timer) > (60 * 1000) Then MsgBox(16, "AndyRoot", "Unable to close the following processes within 60 seconds:" & @CRLF & @CRLF & "adb.exe" & @CRLF & "Andy.exe" & @CRLF & "AndyADB.exe" & @CRLF & "AndyConsole.exe" & @CRLF & "AndyDND.exe" & @CRLF & "HandyAndy.exe" & @CRLF & @CRLF & "Please terminate these processes to continue.")
	Until ProcessExists("Andy.exe") = 0
EndFunc   ;==>CloseAndy
Func AndyRoot()
	$count += 1
	If ProcessExists("AndyConsole.exe") = 0 Or ProcessExists("AndyADB.exe") = 0 Then TrayTip("AndyRoot", "Starting Andy. This can take a while.", 10)
	If ProcessExists("AndyConsole.exe") = 0 Then
		ShellExecute("Andy.exe", '', $workingdirectory)
		Do
			Sleep(500)
		Until WinExists("Andy")
		Sleep(5000)
	EndIf
	If ProcessExists("AndyADB.exe") = 0 Then
		ShellExecute("AndyADB.exe", "", $workingdirectory)
		Sleep(5000)
	EndIf
	Sleep(15000)
	$IP = IniRead(@AppDataDir & "\Andy\HandyAndy\HandyAndy.ini", "Current", "ipaddr", "error")
	TrayTip("AndyRoot", "Rooting... Please be patient.", 10)
	$timer = TimerInit()
	AdlibRegister("CheckTimer", 1000)
	ShellExecuteWait("adb.exe", "connect " & $IP, $tempDir, "", @SW_HIDE)
	Sleep(5000)
	ShellExecuteWait("adb.exe", "root", $tempDir, "", @SW_HIDE)
	ShellExecuteWait("adb.exe", "install Superuser.apk", $tempDir, "", @SW_HIDE)
	Sleep(5000)
	ShellExecuteWait("adb.exe", "install Superuser.apk", $tempDir, "", @SW_HIDE) ;Fix for Superuser not installing on the first try. I have no clue why it fails on the first time.
	ShellExecuteWait("adb.exe", "install rootcheck.apk", $tempDir, "", @SW_HIDE)
	ShellExecuteWait("adb.exe", "push su /storage/sdcard0/", $tempDir, "", @SW_HIDE)
	ShellExecuteWait("adb.exe", 'shell "mount -o remount,rw /system"; "cp /storage/sdcard0/su" "/system/xbin/su"; "chmod 06755 /system/xbin/su"; "mount -o remount,ro /system"', $tempDir, "", @SW_HIDE)
	ShellExecuteWait("adb.exe", "reboot", $tempDir, "", @SW_HIDE)
	AdlibUnRegister("CheckTimer")
	MsgBox(0, "Andy", "Please run Root Checker Basic in Andy and click Verify Root. If you were asked for root access, then root succeeded. If root did not succeed, rerun this app.")
EndFunc   ;==>AndyRoot
Func CheckTimer()
	If TimerDiff($timer) > (120 * 1000 * $count) Then
		If $count > 3 Then
			MsgBox(16, "AndyRoot", "AndyRoot is unable to root. Please report the issue to the developer at BetaLeaf@gmail.com." & @CRLF & "Reason: Timeout Occured. Tried " & $count & " times.")
			$mRet = MsgBox(4, "AndyRoot", "Would you like to keep trying?")
			If $mRet <> 6 Then Exit
		EndIf
		TrayTip("AndyRoot", "An error occured during rooting. We have restarted the rooting process for you. Please be patient.", 10)
		Do
			$ret = ProcessClose("adb.exe")
		Until $ret = 0
		AdlibUnRegister("CheckTimer")
		AndyRoot()
	EndIf
EndFunc   ;==>CheckTimer
