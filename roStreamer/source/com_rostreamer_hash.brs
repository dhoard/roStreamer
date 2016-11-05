'
' Function to generate a MD5 hash of a string
'
Function com_rostreamer_hash_MD5(p_string As String) As String

	If ((m.com_rostreamer_hash_DEBUG <> Invalid) And (m.com_rostreamer_hash_DEBUG = True)) Then
	
		com_rostreamer_debug_Debug("com_rostreamer_hash_MD5() p_string = [" + p_string + "]")
	
	End If

	byteArray = CreateObject("roByteArray")
	byteArray.FromAsciiString(p_string)

	If m.com_rostreamer_hash_MD5Digest = invalid Then

		m.com_rostreamer_hash_MD5Digest = CreateObject("roEVPDigest")
		m.com_rostreamer_hash_MD5Digest.Setup("md5")
	
	End If

	result = m.com_rostreamer_hash_MD5Digest.Process(byteArray)
	
	If ((m.com_rostreamer_hash_DEBUG <> Invalid) And (m.com_rostreamer_hash_DEBUG = True)) Then
	
		com_rostreamer_debug_Debug("com_rostreamer_hash_MD5() result = [" + result + "]")
	
	End If
	
	return result

End Function

'
' Function to generate a SHA1 hash of a string
'
Function com_rostreamer_hash_SHA1(p_string As String) As String

	If ((m.com_rostreamer_hash_DEBUG <> Invalid) And (m.com_rostreamer_hash_DEBUG = True)) Then
	
		com_rostreamer_debug_Debug("com_rostreamer_hash_SHA1() p_string = [" + p_string + "]")
	
	End If

	byteArray = CreateObject("roByteArray")
	byteArray.FromAsciiString(p_string)

	If m.com_rostreamer_hash_SHA1Digest = invalid Then

		m.com_rostreamer_hash_SHA1Digest = CreateObject("roEVPDigest")
		m.com_rostreamer_hash_SHA1Digest.Setup("sha1")
	
	End If

	result = m.com_rostreamer_hash_SHA1Digest.Process(byteArray)
	
	If ((m.com_rostreamer_hash_DEBUG <> Invalid) And (m.com_rostreamer_hash_DEBUG = True)) Then
	
		com_rostreamer_debug_Debug("com_rostreamer_hash_SHA1() result = [" + result + "]")
	
	End If	

	return result

End Function

'
' Function to generate a SHA256 hash of a string
'
Function com_rostreamer_hash_SHA256(p_string As String) As String

	If ((m.com_rostreamer_hash_DEBUG <> Invalid) And (m.com_rostreamer_hash_DEBUG = True)) Then
	
		com_rostreamer_debug_Debug("com_rostreamer_hash_SHA256() p_string = [" + p_string + "]")
	
	End If

	byteArray = CreateObject("roByteArray")
	byteArray.FromAsciiString(p_string)

	If m.com_rostreamer_hash_SHA256Digest = invalid Then

		m.com_rostreamer_hash_SHA256Digest = CreateObject("roEVPDigest")
		m.com_rostreamer_hash_SHA256Digest.Setup("sha256")
	
	End If

	result = m.com_rostreamer_hash_SHA256Digest.Process(byteArray)
	
	If ((m.com_rostreamer_hash_DEBUG <> Invalid) And (m.com_rostreamer_hash_DEBUG = True)) Then
	
		com_rostreamer_debug_Debug("com_rostreamer_hash_SHA256() result = [" + result + "]")
	
	End If
	
	return result	

End Function
