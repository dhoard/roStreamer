'
' Function to get the device's unique id
'
Function com_rostreamer_device_GetDeviceUniqueId() As String

	If m.com_rostreamer_device_deviceUniqueId = invalid Then

		m.com_rostreamer_device_deviceUniqueId = CreateObject("roDeviceInfo").GetDeviceUniqueId()
		
	End If
	
	result = m.com_rostreamer_device_deviceUniqueId
	
	If ((m.com_rostreamer_device_DEBUG <> Invalid) And (m.com_rostreamer_device_DEBUG = True)) Then
	
		com_rostreamer_debug_Debug("com_rostreamer_device_GetDeviceUniqueId() result = [" + result + "]")
	
	End If
	
	return result

End Function

'
' Function to return whether the device is in HD mode
'
Function com_rostreamer_device_IsHD() As Object
	
	If m.com_rostreamer_device_isHD = invalid Then
	
		If CreateObject("roDeviceInfo").GetDisplayMode() = "720p" Then
		
			m.com_rostreamer_device_isHD = True
			
		Else
		
			m.com_rostreamer_device_isHD = False
			
		End If
	
	End If
	
	result = m.com_rostreamer_device_isHD
	
	If ((m.com_rostreamer_device_DEBUG <> Invalid) And (m.com_rostreamer_device_DEBUG = True)) Then
	
		com_rostreamer_debug_Debug("com_rostreamer_device_IsHD() result = [" + result + "]")
	
	End If
	
	return result
	
End Function