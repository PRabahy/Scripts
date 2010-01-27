;No commandline
$popup = 1

If($CmdLine[0] < 1) Then
	$name = InputBox("Workstation", "Input the property tag of a workstation", "")
	If (@error) Then Exit
	Call("_Ping", $name)
Else ;has commandline
	For $index = 1 to $CmdLine[0];do all the commands
		If($CmdLine[0] == "NoPop") Then
			$popup = 0
			ContinueLoop
		EndIf
		;allow text files
		If (StringInStr($CmdLine[$index], ".txt")) Then
			$file = FileOpen($CmdLine[$index], 0)
			If $file = -1 Then
				MsgBox(0, "Error", "Unable to open input file.")
				Exit
			EndIf
			While (1)
				$line = FileReadLine($file)
				If @error = -1 Then ;end of file
					ExitLoop
				EndIf
				If($line == "NoPop") Then
					$popup = 0
					ContinueLoop
				EndIf
				Call("_Ping", $line)
			Wend
			FileClose($file)
		Else ;allow workstation names
			Call("_Ping", $CmdLine[$index])
		EndIf
	Next
EndIf

Func _Ping($WorkStation)
	$result = Ping($WorkStation, 2000)
	Switch @error
	Case 1
		$error = " Host_is_offline"
	Case 2
		$error = " Host_is_unreachable"
	Case 3
		$error = " Bad_destination"
	Case 4
		$error = " Other_errors"
	Case Else
		$error = " No_error"
	EndSwitch
    If ($popup) Then
		MsgBox(0,"Result for " & $WorkStation, "Time was " & $result & "ms" & $error, 5)
	EndIf
	FileWriteLine(@ScriptDir & "\" & "PingResult.txt", $WorkStation & " " & $result & $error & @CRLF)
EndFunc