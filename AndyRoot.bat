adb root
adb install Superuser.apk
adb install rootcheck.apk
adb push su /storage/sdcard0/
adb shell "mount -o remount,rw /system"; "cp /storage/sdcard0/su" "/system/xbin/su"; "chmod 06755 /system/xbin/su"; "mount -o remount,ro /system"
adb reboot
