#include <GUIConstantsEx.au3>
; Shows the filenames of all files in the current directory.

If ($CmdLine[0] > 0) Then
	$var = $CmdLine[1]
Else
	$var = FileSelectFolder("Choose a folder to scan.", "", 0, "c:\")
	If (@error == 1) Then
		MsgBox(0, "Error", "That folder cannot be selected.")
		Exit
	EndIf
EndIf

$search = FileFindFirstFile($var & "\*.*") 
If ($search == -1) Then
	MsgBox(0, "Error", "The folder could not be opened.")
	Exit
EndIf

; Check if the search was empty
If (@error == 1) Then
	MsgBox(0, "Error", "The folder is empty")
	Exit
EndIf

$gui = GUICreate("Scanning Folder")
$label = GUICtrlCreateInput("Line 1 Cell 1", 10, 10, 800)
GUISetState(@SW_SHOW)

$fileCount = 0

$answer = search($search, $var)
$answer = "You have " & $fileCount & " files and folder in " & $var & @CRLF & @CRLF & $answer

FileClose($search)

$temp = FileSaveDialog("Choose where to save the log", @DesktopDir & "\", "Log (*.log;*.txt)", 16, "files.log")
If (@error == 1) Then
	Exit
EndIf

$file = FileOpen($temp, 2)
If ($file == -1) Then
	MsgBox(0, "Error", "Could not save file.")
	Exit
EndIf

FileWriteLine($file, $answer)
FileClose($file)

Func search($search, $var)
$toReturn = ""
While (True)
	$file = FileFindNextFile($search) 
	If @error Then
		ExitLoop
	EndIf
	
	$toReturn = $toReturn & $var & "\" & $file & @CRLF
	$fileCount += 1
	If mod($fileCount, 10) = 0 Then ;only update the display every 10 files; helps speed
		GUICtrlSetData($label, $var & "\" & $file)
	EndIf
	
	$attrib = FileGetAttrib($var & "\" & $file)
	If StringInStr($attrib, "D") Then
		$search2 = FileFindFirstFile($var & "\" & $file & "\*.*")
		$toReturn = $toReturn & search($search2, $var & "\" & $file)
	EndIf
	
WEnd

return $toReturn
EndFunc