'
' Function to determine If a Dynamic value is an Array
'
Function com_rostreamer_type_IsArray(p_dynamic as Dynamic) As Boolean

    If (p_dynamic = invalid) Then

        return False

    Else If (GetInterface(p_dynamic, "ifArray") = invalid) Then

        return False

    End If

    return True

End Function

'
' Function to determine If a Dynamic value is an AssociativeArray
'
Function com_rostreamer_type_IsAssociativeArray(p_dynamic as Dynamic) As Boolean

    If (p_dynamic = invalid) Then

        return False

    Else If (GetInterface(p_dynamic, "ifAssociativeArray") = invalid) Then

        return False

    End If

    return True

End Function

'
' Function to determine If a Dynamic value is a Boolean
'
Function com_rostreamer_type_IsBoolean(p_dynamic as Dynamic) As Boolean

    If (p_dynamic = invalid) Then

        return False

    Else If (GetInterface(p_dynamic, "ifBoolean") = invalid) Then

        return False

    End If

    return True

End Function

'
' Function to determine If a Dynamic value is a Float
'
Function com_rostreamer_type_IsFloat(p_dynamic as Dynamic) As Boolean

    If (p_dynamic = invalid) Then

        return False

    Else If (GetInterface(p_dynamic, "ifFloat") = invalid) Then

        return False

    End If

    return True

End Function

'
' Function to determine If a Dynamic value is a Integer
'
Function com_rostreamer_type_IsInteger(p_dynamic as Dynamic) As Boolean

    If (p_dynamic = invalid) Then

        return False

    Else If (GetInterface(p_dynamic, "ifInt") = invalid) Then

        return False

    End If

    return True

End Function

'
' Function to determine If a Dynamic value is a String
'
Function com_rostreamer_type_IsString(p_dynamic as Dynamic) As Boolean

    If (p_dynamic = invalid) Then

        return False

    Else If (GetInterface(p_dynamic, "ifString") = invalid) Then

        return False

    End If

    return True

End Function

'
' Function to convert an object from case sensitive
' (for example the result of ParseJson(string) to
' an object that is case insensitive
'
Function com_rostreamer_type_ToCaseInsensitive(p_object As Object) As Object

	objType = Type(p_object)

	If objType = "roArray" or objType = "roList" Then
	
		For i = 0 To (p_object.Count() - 1)
		
			p_object[i] = com_rostreamer_type_ToCaseInSensitive(p_object[i])
		
		End For
		
		result = p_object
	
	Else If objType = "roAssociativeArray" Then
	
		result = CreateObject("roAssociativeArray")
	
		For Each key In p_object 
			
			value = p_object.Lookup(key)
			value = com_rostreamer_type_ToCaseInSensitive(value)
			
			result.AddReplace(LCase(key), value)
				
		End For
		
	Else
	
		result = p_object
		
	End If

	return result

End Function