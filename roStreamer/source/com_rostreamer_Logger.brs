'
' Object to implement logging
'
Function com_rostreamer_Logger(p_name As String, p_enabled As Boolean) As Object

    this = {
        name : p_name
        enabled : p_enabled
        Enable: x_Enable
        Log: x_Log
    }

    return this

End Function

Sub x_Enable(p_enabled As Boolean)

    m.enabled = p_enabled

End Sub

Sub x_Log(p_message As String)

    If (m.enabled) Then

        print m.name + " | " + p_message

    End If

End Sub