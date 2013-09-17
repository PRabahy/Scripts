textToSpeach("Hi there my name is Paul")

Func textToSpeach($input)
	$temp = StringReplace($input, " ", "+")
	InetGet("http://translate.google.com/translate_tts?q=" & $temp, @TempDir & "\test.mp3")
	SoundPlay(@TempDir & "\test.mp3", 1)
	FileDelete(@TempDir & "\test.mp3")
EndFunc