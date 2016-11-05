'
' Function to determine if a string ends with a suffix string
'
Function com_rostreamer_string_EndsWith(p_string As String, p_suffixString As String) As Boolean

    stringLength = Len(p_string)
    suffixStringLength = Len(p_suffixString)

    if (suffixStringLength > stringLength) then

        return False

    end if

    return Right(p_string, suffixStringLength) = p_suffixString

End Function

'
' Function to get pseudo-random string
'
Function com_rostreamer_string_RandomString(p_length As Integer) As String

    characters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
	result = ""

    for i = 1 to p_length

        result = result + characters.Mid(Rnd(62) - 1, 1)

    end for

    return result

End Function

'
' Function to get pseudo-random hex string
'
Function com_rostreamer_string_RandomHexString(p_length As Integer) As String

    characters = "0123456789ABCDEF"
    result = ""

    for i = 1 to p_length

        result = result + characters.Mid(Rnd(16) - 1, 1)

    end for

    return result

End Function

'
' Function to replace all occurs of one substring with another substring
'
Function com_rostreamer_string_ReplaceAll(p_string As String, p_oldString As String, p_newString As String) As String

    result = ""

    i = 1
    while i <= Len(p_string)

        x = Instr(i, p_string, p_oldString)

        if x = 0 then

            result = result + Mid(p_string, i)
            exit while

        endif

        if x > i then

            result = result + Mid(p_string, i, x-i)
            i = x

        endif

        result = result + p_newString
        i = i + Len(p_oldString)

    end while

    return result

End Function

'
' Function to determine if a string starts with a prefix string
'
Function com_rostreamer_string_StartsWith(p_string As String, p_prefixString As String) As Boolean

    stringLength = Len(p_string)
    prefixStringLength = Len(p_prefixString)

    if (prefixStringLength > stringLength) then

        return False

    end if

    return Left(p_string, prefixStringLength) = p_prefixString

End Function

'
' Function to convert a Dynamic value to a String
'
Function com_rostreamer_string_ToString(p_dynamic As Dynamic) As String

    If (p_dynamic = invalid) Then

        return invalid

    Else If com_rostreamer_type_IsString(p_dynamic) Then

        return p_dynamic

    Else If com_rostreamer_type_IsInteger(p_dynamic) Then

        return com_rostreamer_string_Trim(stri(p_dynamic))

    Else If com_rostreamer_type_IsBoolean(p_dynamic) Then

        If (p_dynamic = True) Then

            return "true"

        Else

            return "false"

        End If

    Else If com_rostreamer_type_Isfloat(p_dynamic) Then

        return com_rostreamer_string_Trim(Str(p_dynamic))

    End If

    return invalid

End Function

'
' Function to trim a string of leading and trailing empty characters
'
Function com_rostreamer_string_Trim(p_string As String) As String

    result = CreateObject("roString")
    result.SetString(p_string)

    return result.Trim()

End Function
