'*
'* Function to download / return a pkg reference to a remove file
'*
Function com_rostreamer_url_Pkg(p_url As String) As Object

	result = ""

    If p_url <> invalid Then
        
	    filename = "tmp:/" + RandomString(32)
    
   		urlTransfer = CreateObject("roUrlTransfer")
    	urlTransfer.SetURL(ToString(p_url))
    	urlTransfer.SetCertificatesFile("pkg:/certs/RootCA.crt")

		responseCode = urlTransfer.GetToFile(filename)
    
    	If responseCode = 200 Then
    
        	result = filename

    	End If

	End If

    return result

End Function

'*
'* Function to add a nocache parameter to a URL
'*
Function com_rostreamer_url_AddNoCache(p_url As String) As Object
    
    If m.noCache = invalid Then
    
        dateTime = CreateObject("roDateTime")
    
        'm.noCache = "nocache=" + dateTime.getYear().ToStr() + "-" + dateTime.getMonth().ToStr() + "-" + dateTime.getDayOfMonth().ToStr()
        'm.noCache = m.noCache + "_" + dateTime.getHours().ToStr() '+ "_" + dateTime.asSeconds().toStr()
        m.noCache = "nocache=" + com_rostreamer_string_RandomHexString(32)
    
    End If
    
    If p_url <> invalid Then
	
		If InStr(1, p_url, "?") = 0 Then
	
			p_url = p_url + "?" + m.noCache
	
		Else
	
			p_url = p_url + "&" + m.noCache
    
        End If
    
    End If
    
    return p_url

End Function

'*
'* Function to strip a query string from a URL
'*
Function com_rostreamer_url_StripQueryString(p_url As String) As String

	index = InStr(1, p_url, "?")
	
	If index <> 0 Then
	
		p_url = Left(p_url, index - 1)
		
	End If
	
	return p_url 

End Function

'*
'* Function to unescape a string
'*
Function com_rostreamer_url_Unescape(p_string As String) As String

	If p_string <> invalid Then

		If m.urlEncoder = invalid Then
	
			m.urlEncoder = CreateObject("roUrlTransfer")
	
		End If

		p_string = m.urlEncoder.unescape(p_string)
	
	End If
	
	return p_string

End Function

'*
'* Function to url encode a string
'*
Function com_rostreamer_url_UrlEncode(p_string As String) As String

	If p_string <> invalid Then

		If m.urlEncoder = invalid Then
	
			m.urlEncoder = CreateObject("roUrlTransfer")
	
		End If

		p_string = m.urlEncoder.UrlEncode(p_string)
	
	End If
	
	return p_string
	
End Function

'*
'* Function to url decode a string
'*
Function com_rostreamer_url_UrlDecode(p_string As String) As String

	If p_string <> invalid Then

		If m.urlEncoder = invalid Then
	
			m.urlEncoder = CreateObject("roUrlTransfer")
	
		End If

		p_string = m.urlEncoder.Unescape(p_string)
	
	End If
	
	return p_string
	
End Function
