cd ~
7z.exe x game.zip -oc:\game

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Default\Desktop\GameFiles.lnk")
$Shortcut.TargetPath = "C:\game"
$Shortcut.Save()
