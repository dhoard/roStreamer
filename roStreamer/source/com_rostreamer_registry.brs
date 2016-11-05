'
' Function to get a registry section
'
Function com_rostreamer_registry_GetSection(p_section As String) As Object

	return CreateObject("roRegistrySection", p_section)

End Function

'
' Function to delete a registry key
'
Sub com_rostreamer_registry_DeleteKey(p_section As String, p_key As String)

    registrationSection = CreateObject("roRegistrySection", p_section)
    registrationSection.Delete(p_key)
    registrationSection.Flush()

End Sub

'
' Function to determine if a registry key exists
'
Function com_rostreamer_registry_KeyExists(p_section As String, p_key As String) As Boolean

    registrationSection = CreateObject("roRegistrySection", p_section)

    return registrationSection.Exists(p_key)

End Function

'
' Function to read a registry value
'
Function com_rostreamer_registry_Read(p_section As String, p_key As String) As Object

    registrationSection = CreateObject("roRegistrySection", p_section)

    if registrationSection.Exists(p_key) then

        return registrationSection.Read(p_key)

    else

        return invalid

    end if

End Function

'
' Function to read a registry value as an int
'
Function com_rostreamer_registry_ReadAsInt(p_section As String, p_key As String, p_defaultValue As Integer) As Integer

	result = com_rostreamer_registry_Read(p_section, p_key)
	
	If result = invalid Then
	
		return p_defaultValue
		
	Else
	
		return strtoi(p_defaultValue)
	
	End If

End Function

'
' Subroutine write a registry value
'
Sub com_rostreamer_registry_Write(p_section As String, p_key As String, p_value As String)

    registrationSection = CreateObject("roRegistrySection", p_section)
    registrationSection.Write(p_key, p_value)
    registrationSection.Flush()

End Sub

'
' Subroutine to write a registry value as an int
'
Sub com_rostreamer_registry_WriteAsInt(p_section As String, p_key As String, p_value As Integer)

	com_rostreamer_registry_Write(p_section, p_key, ToString(p_value))

End Sub
