#include <File.au3>
#include <Array.au3>

Opt("TrayAutoPause", 0)

Global $sOnlineFile = "Online.txt"
Global $sOfflineFile = "Offline.txt"
Global $sOutputFile = "Log.txt"
Global $iDelay = 10000

While 1
	;_Output("Scanning Online PCs")
	CheckOnline()
	;_Output("Scanning Offline PCs")
	CheckOffline()
	Sleep($iDelay)
WEnd

;_FileDeleteLine("Online.txt", "abc")

Func CheckOnline()
	Local $aRecords
	Local $aToRemove[1]
	If Not _FileReadToArray($sOnlineFile,$aRecords) Then
	   _Output(" Error reading log to Array     error:" & @error)
	   Return 0
   EndIf
   
	For $x = 1 to $aRecords[0]
		If Ping($aRecords[$x]) = 0 Then
			_Output($aRecords[$x] & " went offline")
			FileWriteLine($sOfflineFile, $aRecords[$x])
			_ArrayAdd($aToRemove, $aRecords[$x])
		EndIf
	Next
	
	_ArrayDelete($aRecords, 0)
	_FileWriteFromArray($sOnlineFile, $aRecords)
	
	If IsArray($aToRemove) Then
		For $element In $aToRemove
			_FileDeleteLine($sOnlineFile, $element)
		Next
	EndIf
	
	Return 1
EndFunc

Func CheckOffline()
	Local $aRecords
	Local $sToReturn
	Local $aToRemove[1]
	If Not _FileReadToArray($sOfflineFile,$aRecords) Then
	   _Output(" Error reading log to Array     error:" & @error)
	   Return 0
   EndIf
   
	For $x = 1 to $aRecords[0]
		If Ping($aRecords[$x]) Then
			_Output($aRecords[$x] & " came online", 3)
			FileWriteLine($sOnlineFile, $aRecords[$x])
			_ArrayAdd($aToRemove, $aRecords[$x])
		EndIf
	Next
	
	_ArrayDelete($aRecords, 0)
	_FileWriteFromArray($sOfflineFile, $aRecords)
	
	If IsArray($aToRemove) Then
		For $element In $aToRemove
			_FileDeleteLine($sOfflineFile, $element)
		Next
	EndIf
	
	Return 1
EndFunc

Func _Output($sOutput, $iFlag = 1)
	If BitAnd($iFlag, 1) Then
		_FileWriteLog($sOutputFile, $sOutput, 1)
	EndIf
	If BitAnd($iFlag, 2) Then
		MsgBox(0,"", $sOutput)
	EndIf
EndFunc

Func _FileDeleteLine($sFileName, $sToDelete)
	Local $aRecords
	_FileReadToArray($sFileName, $aRecords)
	Local $File = FileOpen($sFileName, 2)
	For $x = 1 to $aRecords[0]
		If $aRecords[$x] == $sToDelete Then 
		Else
			FileWriteLine($File, $aRecords[$x])
		EndIf
	Next
	FileClose($File)
EndFunc