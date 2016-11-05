'
' Function to get JSON from a url
'
Function com_rostreamer_json_GetJSON(p_url As String, p_defaultFile As String) As Object

	If ((m.com_rostreamer_json_DEBUG <> Invalid) And (m.com_rostreamer_json_DEBUG = True)) Then
	
		com_rostreamer_debug_eToDbug("com_rostreamer_json_GetJSON() p_url = [" + p_url + "]")
	
	End If

    If p_url = invalid then
    
        return { error : -1, errorString : "Invalid URL" }

    End If
    
	If com_rostreamer_string_EndsWith(p_url, "/") = True Then
	
		p_url = p_url + p_defaultFile
		
	End If
 
 	If ((m.com_rostreamer_json_DEBUG <> Invalid) And (m.com_rostreamer_json_DEBUG = True)) Then
	
		com_rostreamer_debug_Debug("com_rostreamer_json_GetJSON() p_url = [" + p_url + "]")
	
	End If 
    
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetURL(p_url)
    'urlTransfer.AddHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3")

    filename = "tmp:/" + com_rostreamer_string_RandomString(32)

	If ((m.com_rostreamer_json_DEBUG <> Invalid) And (m.com_rostreamer_json_DEBUG = True)) Then
	
		com_rostreamer_debug_Debug("com_rostreamer_json_GetJSON() filename = [" + filename + "]")
	
	End If

    responseCode = urlTransfer.GetToFile(filename)
    
	If ((m.com_rostreamer_json_DEBUG <> Invalid) And (m.com_rostreamer_json_DEBUG = True)) Then
	
		com_rostreamer_debug_Debug("com_rostreamer_json_GetJSON() responseCode = [" + com_rostreamer_string_ToString(responseCode) + "]")
	
	End If    
    
    If responseCode <> 200 then
    
    	If ((m.com_rostreamer_json_DEBUG <> Invalid) And (m.com_rostreamer_json_DEBUG = True)) Then
    	
    		com_rostreamer_debug_Debug("com_rostreamer_json_GetJSON() responseCode = [" + ToString(responseCode) + "]")
    	
    	End If
    
        return { error : responseCode, errorString : "HTTP error" }

    End If

	If ((m.com_rostreamer_json_DEBUG <> Invalid) And (m.com_rostreamer_json_DEBUG = True)) Then

		com_rostreamer_debug_Debug("com_rostreamer_json_GetJSON() json = [" + ReadAsciiFile(filename) + "]")
		
	End If

    json = ParseJson(ReadAsciiFile(filename))
    
    If json = invalid then
    
        return  { error : -2, errorString : "Invalid JSON" }
    
    End If

	json = com_rostreamer_type_ToCaseInsensitive(json)
        
    return { error : 0, json : json }

End Function

'
' Function to convert an object to a JSON string
'
Function com_rostreamer_json_ToJSON(p_object as Dynamic) as String
	
	DOUBLE_QUOTE = chr(34)
	result = ""
	
	p_object = box(p_object)	
	valueType = type(p_object)
	
	If (valueType = "roString") Or (valueType = "String") Then
	
		p_object = com_rostreamer_string_ReplaceAll(p_object, DOUBLE_QUOTE, "\" + DOUBLE_QUOTE) 
		p_object = com_rostreamer_string_ReplaceAll(p_object, "/", "\/")
		
		result = result + DOUBLE_QUOTE + p_object + DOUBLE_QUOTE
	
	Else If (valueType = "roInt") Or (valueType = "Integer") Then
		
		result = result + p_object.tostr()
	
	Else If (valueType = "roBoolean") Or (valueType = "Boolean") Then
	
		If p_object = True Then
		
			result = result + "true"
		
		Else
		
			result = result + "false"
			
		End If
		
	Else If (valueType = "roFloat") Or (valueType = "Float") Then
		
		result = result + str(p_object)
		
	Else If (valueType = "roDouble") Or (valueType = "Double") Then
	
		result = result + str(p_object)
		
	Else If (valueType = "roList") Or (valueType = "roArray") Then
	
		result = result + "["
		separator = ""
	
		For Each child In p_object
		
			result = result + separator + com_rostreamer_json_ToJSON(child)
			
			separator = ","
		
		End For
		
		result = result + "]"
	
	Else If valueType = "roAssociativeArray" Then
	
		result = result + "{"
		separator = ""
	
		For Each key In p_object
		
			result = result + separator + com_rostreamer_json_ToJSON(key) + ":"
			result = result + com_rostreamer_json_ToJSON(p_object[key])
			
			separator = ","
	
		End For
	
		result = result + "}"
	
	Else

		com_rostreamer_debug_Debug("Unhandled type = [" + valueType + "]")
		
		stop
	
	End If
	
	return result
	
End Function
