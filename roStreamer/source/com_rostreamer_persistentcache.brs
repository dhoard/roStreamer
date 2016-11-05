'
' Object to implement a persistent cache of a maximum size
'
Function com_rostreamer_persistentcache_PersistentCache(p_name As String, p_size As Integer) As Object

    this = {
        name : p_name
        size : p_size
        registrySectionData : CreateObject("roRegistrySection", p_name + ".data")
        registrySectionTimestamp : CreateObject("roRegistrySection", p_name + ".timestamp")
        logger : Invalid
        
        Put: PersistentCache_Put
        ContainsKey: PersistentCache_ContainsKey
        Get: PersistentCache_Get        
        Remove: PersistentCache_Remove
        Clear: PersistentCache_Clear
        
        MD5: PersistentCache_MD5
    }

    return this

End Function

Sub PersistentCache_Put(p_key As String, p_value As String)

    If (m.logger <> Invalid) Then
    
        m.logger.Log("Put [" + p_key + "] [" + p_value + "]")
    
    End If

    md5key = m.MD5(p_key)
    
    m.registrySectionData.Write(md5key, p_value)
    m.registrySectionTimestamp.Write(md5key, CreateObject("roDateTime").AsSeconds().ToStr())
    
    While (m.registrySectionData.GetKeyList().Count() > m.size)
        
        oldestKey = m.registrySectionData.GetKeyList()[0]
        oldestTimestamp = m.registrySectionTimestamp.Read(oldestKey).ToInt()
        
        For Each key In m.registrySectionData.GetKeyList()
        
            tempTimestamp = m.registrySectionTimestamp.Read(key).ToInt()
            
            If (tempTimestamp < oldestTimestamp) Then
            
                oldestKey = key
                oldestTimestamp = tempTimestamp
                
            End If
        
        End For
    
        If (m.logger <> Invalid) Then
    
            m.logger.Log("Purge [" + oldestKey + "]")
    
        End If
    
        m.registrySectionData.Delete(oldestKey)
        m.registrySectionTimestamp.Delete(oldestKey)
    
    End While

    m.registrySectionData.Flush()
    m.registrySectionTimestamp.Flush()
    
    If (m.logger <> Invalid) Then
    
        m.logger.Log("Size [" + com_rostreamer_string_ToString(m.registrySectionData.GetKeyList().Count()) + "]")
    
    End If

End Sub

Function PersistentCache_ContainsKey(p_key As String) As Boolean

    md5key = m.MD5(p_key)
    
    result = m.registrySectionData.Exists(md5key)
    
    If (m.logger <> Invalid) Then
    
        m.logger.Log("ContainsKey [" + p_key + "] = [" + com_rostreamer_string_ToString(result) + "]")
    
    End If

    return result

End Function

Function PersistentCache_Get(p_key As String) As Object

    md5key = m.MD5(p_key)

    result = Invalid

    If (m.registrySectionData.Exists(md5key)) Then
    
        result = m.registrySectionData.Read(md5key)
        
    End If
    
    If (m.logger <> Invalid) Then
    
        m.logger.Log("Get [" + p_key + "] = [" + result + "]")
    
    End If
    
    return result

End Function

Sub PersistentCache_Remove(p_key As String)

    If (m.logger <> Invalid) Then
    
        m.logger.Log("Remove [" + p_key + "]")
    
    End If

    md5key = m.MD5(p_key)

    m.registrySectionData.Delete(md5key)
    m.registrySectionTimestamp.Delete(md5key)
    
    m.registrySectionData.Flush()
    m.registrySectionTimestamp.Flush()

End Sub

Sub PersistentCache_Clear()

    If (m.logger <> Invalid) Then
    
        m.logger.Log("Clear")
    
    End If

    For Each key In m.registrySectionData.GetKeyList()
    
        m.registrySectionData.Delete(key)
        m.registrySectionTimestamp.Delete(key)
    
    End For
    
    m.registrySectionData.Flush()
    m.registrySectionTimestamp.Flush()

End Sub

Function PersistentCache_MD5(p_string As String) As String

    byteArray = CreateObject("roByteArray")
    byteArray.FromAsciiString(p_string)

    md5Digest = CreateObject("roEVPDigest")
    md5Digest.Setup("md5")

    result = md5Digest.Process(byteArray)
    
    If (m.logger <> Invalid) Then
    
        m.logger.Log("MD5 [" + p_string + "] = [" + result + "]")
    
    End If
    
    return result

End Function