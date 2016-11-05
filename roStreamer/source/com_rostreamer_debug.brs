'
' Function to show a debug sceen
'
Sub com_rostreamer_debug_Debug(p_message As String)

	debugScreen = com_rostreamer_screen_CreateTextScreen(p_message)
	debugScreen.Show()
	
	wait(0, debugScreen.GetMessagePort())

   	debugScreen.Close()

End Sub