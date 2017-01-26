#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=AndyRoot_99.ico
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <AutoItConstants.au3>
#include <FileConstants.au3>
#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
Opt("WinTitleMatchMode", 3)
$workingdirectory = "C:\Program Files\Andy"
$tempDir = @TempDir & "\BetaLeaf Software\AndyRoot\"
Global $timer, $count = 1, $Step = "INIT"
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
			ProgressOn("AndyRoot", "Downloading...")
			Do
				$hDownload = InetGet("http://downloads.andyroid.net/installer/v46/Andy_46.8_326_" & StringLower(@OSArch) & "bit.exe", "AndyIns.exe", $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
				While InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE) = False
					ProgressSet(InetGetInfo($hDownload, $INET_DOWNLOADREAD) / InetGetInfo($hDownload, $INET_DOWNLOADSIZE) * 110, "Downloaded " & Round(InetGetInfo($hDownload, $INET_DOWNLOADREAD) / 1000000, 2) & " MB of " & Round(InetGetInfo($hDownload, $INET_DOWNLOADSIZE) / 1000000, 2) & " MB.")
					Select
						Case InetGetInfo($hDownload, $INET_DOWNLOADSUCCESS) = True
							ConsoleWrite("Success!" & @CRLF)
							ExitLoop
						Case InetGetInfo($hDownload, $INET_DOWNLOADERROR) = True
							ConsoleWrite("Failed." & @CRLF)
							ProgressSet(0,"Download Failed. Retrying...")
							sleep(2000)
							ExitLoop
					EndSelect
					Sleep((1000 / @DesktopRefresh) + 1)
				WEnd
			Until InetGetInfo($hDownload, $INET_DOWNLOADSUCCESS) = True
			ProgressOff()
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
AndyRoot()
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
	If $IP = "error" Then
		MsgBox(16, "AndyRoot", "Could not get IP for Andy Emulator. Please report the issue to the developer at BetaLeaf@gmail.com." & @CRLF & @CRLF & "Error: NOIPFOUND.")
		Exit
	EndIf
	TrayTip("AndyRoot", "Rooting... Please be patient.", 10)
	$timer = TimerInit()
	AdlibRegister("CheckTimer", 1000)
	$Step = "ADB_CONNECT"
	ShellExecuteWait("adb.exe", "connect " & $IP, $tempDir, "", @SW_HIDE)
	Sleep(5000)
	$Step = "ADB_ROOT"
	ShellExecuteWait("adb.exe", "root", $tempDir, "", @SW_HIDE)
	$Step = "ADB_SUPERUSER1"
	ShellExecuteWait("adb.exe", "install Superuser.apk", $tempDir, "", @SW_HIDE)
	Sleep(5000)
	$Step = "ADB_SUPERUSER2"
	ShellExecuteWait("adb.exe", "install Superuser.apk", $tempDir, "", @SW_HIDE) ;Fix for Superuser not installing on the first try. I have no clue why it fails on the first time.
	$Step = "ADB_ROOTCHECK"
	ShellExecuteWait("adb.exe", "install rootcheck.apk", $tempDir, "", @SW_HIDE)
	$Step = "ADB_PUSHSU"
	ShellExecuteWait("adb.exe", "push su /storage/sdcard0/", $tempDir, "", @SW_HIDE)
	$Step = "ADB_REMOUNT"
	ShellExecuteWait("adb.exe", 'shell "mount -o remount,rw /system"; "cp /storage/sdcard0/su" "/system/xbin/su"; "chmod 06755 /system/xbin/su"; "mount -o remount,ro /system"', $tempDir, "", @SW_HIDE)
	$Step = "ADB_REBOOT"
	ShellExecuteWait("adb.exe", "reboot", $tempDir, "", @SW_HIDE)
	$Step = "ADB_DONE"
	AdlibUnRegister("CheckTimer")
	MsgBox(0, "Andy", "Please run Root Checker Basic in Andy and click Verify Root. If you were asked for root access, then root succeeded. If root did not succeed, rerun this app.")
EndFunc   ;==>AndyRoot
Func CheckTimer()
	If TimerDiff($timer) > (60 * 1000 * $count) Then
		If $count > 4 Then
			MsgBox(16, "AndyRoot", "AndyRoot is unable to root. Please report the issue to the developer at BetaLeaf@gmail.com." & @CRLF & @CRLF & "Error: TIMEOUT_OCCURED_ON_STEP_" & $Step & ".")
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
