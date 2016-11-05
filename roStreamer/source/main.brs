'
' Main subroutine
'
Sub Main()

    m.logger = com_rostreamer_Logger("Main", false)
    m.DEBUG = false
    m.com_rostreamer_json_DEBUG = false

    m.persistentCache = com_rostreamer_persistentcache_PersistentCache("MRU", 100)

    If (m.logger.enabled) Then

        m.DEBUG = true
        m.com_rostreamer_json_DEBUG = true
        m.persistentCache.logger = com_rostreamer_Logger("PersistentCache", True)

    End If

    DefineConstants()
    InitializeTheme()

    baseScreen = com_rostreamer_screen_CreateBaseScreen()
    baseScreen.Show()

    jsonFeedUrl = com_rostreamer_registry_Read("Configuration", "jsonFeedUrl")

    If (jsonFeedUrl = invalid) Then

        jsonFeedUrl = ShowConfigurationScreen("http://")
        com_rostreamer_registry_Write("Configuration", "jsonFeedUrl", jsonFeedUrl)

    Else

        message = wait(1000, baseScreen.GetMessagePort())

        If (message <> invalid) And (message.IsRemoteKeyPressed()) And (message.GetIndex() = 10) Then

            jsonFeedUrl = ShowConfigurationScreen(jsonFeedUrl)
            com_rostreamer_registry_Write("Configuration", "jsonFeedUrl", jsonFeedUrl)

        End If

    End If

    ShowContent(jsonFeedUrl, "contentMetaData.json")

End Sub

Sub DefineConstants()

    m.EMPTY_STRING = ""
    m.NO_ERROR = 0
    m.INVALID_JSON_FORMAT = -2
    m.INVALID_JSON_FORMAT_STRING = "Invalid JSON format"

End Sub

'
' Subroutine to initialize the theme
'
Sub InitializeTheme()

    theme = CreateObject("roAssociativeArray")
    theme.OverhangLogoHD = "pkg:/images/Overhang_Background_HD.png"
    theme.OverhangSliceHD = ""
    theme.OverhangOffsetHD_X = "0"
    theme.OverhangOffsetHD_Y = "0"
    theme.OverhangLogoSD = "pkg:/images/Overhang_Background_SD.png"
    theme.OverhangSliceSD = ""
    theme.OverhangOffsetSD_X = "0"
    theme.OverhangOffsetSD_Y = "0"
    theme.BackgroundColor = "#000000"

    appManager = CreateObject("roAppManager")
    appManager.SetTheme(theme)

End Sub

'
' Function to show a configuration screen
'
Function ShowConfigurationScreen(p_jsonFeedUrl As String) As String

    keyboardScreen = CreateObject("roKeyboardScreen")
    keyboardScreen.SetMessagePort(CreateObject("roMessagePort"))
    keyboardScreen.SetTitle("Configuration")
    keyboardScreen.SetDisplayText("Enter your jsonFeedUrl")
    keyboardScreen.SetText(p_jsonFeedUrl)
    keyboardScreen.SetMaxLength(256)
    keyboardScreen.AddButton(1, "Save")
    keyboardScreen.AddButton(2, "Cancel")
    keyboardScreen.Show()

    While True

        message = wait(0, keyboardScreen.GetMessagePort())

        If type(message) = "roKeyboardScreenEvent" Then

            If message.isScreenClosed() Then

                return p_jsonFeedUrl

            Else If message.isButtonPressed() Then

                If message.getIndex() = 1 Then

                    return keyboardScreen.GetText()

                Else If message.getIndex() = 2 Then

                    return p_jsonFeedUrl

                End If

            End If

        End If

    End While

End Function

'
' Subroutine to show content
'
Sub ShowContent(p_jsonFeedUrl As Object, p_defaultJsonFeedFilename As String)

    If ((m.DEBUG <> Invalid) And (m.DEBUG = True)) Then

        com_rostreamer_debug_Debug("ShowContent() p_jsonFeedUrl = [" + p_jsonFeedUrl + "]")

    End If

    If com_rostreamer_string_EndsWith(p_jsonFeedUrl, "/") Then

        p_jsonFeedUrl = p_jsonFeedUrl + p_defaultJsonFeedFilename

    End If

    retrievingScreen = com_rostreamer_screen_CreateTextScreen("Retrieving ...")
    retrievingScreen.Show()

    result = com_rostreamer_json_GetJSON(p_jsonFeedUrl, p_defaultJsonFeedFilename)

    If result.error <> 0 Then

        retrievingScreen.Close()
        com_rostreamer_screen_ShowErrorScreen(result.errorString + " : " + com_rostreamer_string_ToString(result.error))

        return

    End If

    jsonFeed = result.json

    ' Resolve relative links
    jsonFeed = ResolveRelativeLinks(p_jsonFeedUrl, p_defaultJsonFeedFilename, jsonFeed)

    categoryPosterScreen = com_rostreamer_screen_CreateFlatCategoryPosterScreen()
    categoryPosterScreen.SetContentList(jsonFeed)
    'categoryPosterScreen.SetBreadcrumbText("", "1 | " + com_rostreamer_string_ToString(categoryPosterScreen.GetContentList().Count()))
    categoryPosterScreen.Show()
    retrievingScreen.Close()

    While True

        MAIN_LOOP:

        message = wait(0, categoryPosterScreen.GetMessagePort())

        If message = invalid or message.isScreenClosed() Then

            return

        Else If message.isListItemSelected() Then

            contentMetaData = categoryPosterScreen.GetContentList()[message.GetIndex()]

            If contentMetaData.jsonfeedurl <> invalid Then

                ShowContent(contentMetaData.jsonfeedurl, p_defaultJsonFeedFilename)

            Else If (contentMetaData.streamurls <> invalid) And (contentMetaData.streamurls.Count() > 0) Then

                PlayContent(contentMetaData)

            End If

        Else

            'categoryPosterScreen.SetBreadcrumbText("", ToString(message.GetIndex() + 1) + " | " + ToString(categoryPosterScreen.GetContentList().Count()))

        End If

    End While

End Sub

'
' Subroutine to play content
'
Sub PlayContent(p_contentMetaData As Object)

    m.logger.Log("PlayContent() p_contentMetaData.streamurls[0] = [" + p_contentMetaData.streamurls[0] + "]")

    If ((m.DEBUG <> Invalid) And (m.DEBUG = True)) Then

        com_rostreamer_debug_Debug("PlayContent p_contentMetaData.streamurls[0] = [" + p_contentMetaData.streamurls[0] + "]")

    End If

    p_contentMetaData.playstart = 0
    p_contentMetaData.streamstarttimeoffset = 0

    If (p_contentMetaData.streamformat = "mp4") Then

        If (m.persistentCache.ContainsKey(p_contentMetaData.streamurls[0])) Then

            playstart = m.persistentCache.Get(p_contentMetaData.streamurls[0]).ToInt()

            If (playstart > 0) Then

                action = ShowResumeScreen(p_contentMetaData)

                ' back arrow / screen closed
                If (action = 0) Then

                    return

                ' resume playback
                Else If (action = 1) Then

                    ' DO NOTHING

                ' play from beginning
                Else If (action = 2) Then

                    m.persistentCache.Remove(p_contentMetaData.streamurls[0])

                    playstart = 0

                ' reset playback then close screen
                Else If (action = 3) Then

                    m.persistentCache.Remove(p_contentMetaData.streamurls[0])

                    p_contentMetaData.playstart = 0
                    p_contentMetaData.streamstarttimeoffset = 0

                    return

                End If

                p_contentMetaData.playstart = playstart
                p_contentMetaData.streamstarttimeoffset = playstart

            End If

        End If

    End If

    If ((m.DEBUG <> Invalid) And (m.DEBUG = True)) Then

        com_rostreamer_debug_Debug("com_rostreamer_screen_PlayContent() Done getting playback position")

    End If

    videoScreen = CreateObject("roVideoScreen")
    videoScreen.SetMessagePort(CreateObject("roMessagePort"))
    videoScreen.SetPositionNotificationPeriod(10)
    videoScreen.AddHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3")
    videoScreen.SetContent(p_contentMetaData)
    videoScreen.Show()

    While True

        message = wait(0, videoScreen.GetMessagePort())

        If Type(message) = "roVideoScreenEvent" Then

            If message.IsScreenClosed() Then

                videoScreen.Close()

                exit while

            Else If message.IsPlaybackPosition() Then

                If message.GetIndex() > 0 Then

                    If p_contentMetaData.streamformat = "mp4" Then

                        m.persistentCache.Put(p_contentMetaData.streamurls[0], com_rostreamer_string_ToString(message.GetIndex()))

                    End If

                End If

            Else If message.IsFullResult() Then

                If p_contentMetaData.streamformat = "mp4" Then

                    m.persistentCache.Remove(p_contentMetaData.streamurls[0])

                End If

            Else If message.IsRequestFailed() Then

                videoScreen.Close()

                errorScreen = com_rostreamer_screen_CreateTextScreen("Playback failed : " + message.GetMessage())
                errorScreen.Show()

                wait(5000, errorScreen.GetMessagePort())

                errorScreen.Close()

                return

            Else If message.IsPaused()

            Else If message.IsResumed()

            Else If message.IsStatusMessage() Then

                If (message.GetMessage() = "end of stream") Then

                    videoScreen.Close()

                    If p_contentMetaData.streamformat = "mp4" Then

                        m.persistentCache.Remove(p_contentMetaData.streamurls[0])

                    End If

                    return

                End If

            End If

        End If

    End While

End Sub

'
' Function to show a resume screen
'
Function ShowResumeScreen(p_contentMetaData As Object) As Object

    result = 0

    dialog = CreateObject("roMessageDialog")
    dialog.SetMessagePort(CreateObject("roMessagePort"))
    dialog.EnableBackButton(True)
    dialog.SetTitle("Playback")
    dialog.AddButton(1, "Resume playing")
    dialog.AddButton(2, "Play from beginning")
    dialog.AddButton(3, "Clear playback position")
    dialog.Show()

    While True

        message = wait(0, dialog.GetMessagePort())

        If Type(message) = "roMessageDialogEvent" Then

            If message.IsButtonPressed() Then

                result = message.GetIndex()

                exit While

            Else If message.IsScreenClosed() Then

                result = 0

                exit While

            End If

        End If

    End While

    dialog.Close()

    return result

End Function

Function ResolveRelativeLinks(p_url As String, p_defaultFile As String, p_contentMetaData As Object) As Object

    ' base url http://foo.com/bar/test.txt ==> http://foo.com
    baseUrl = "http://" + Left(Mid(p_url, 8), Instr(0, Mid(p_url, 8), "/") - 1)

    If ((m.DEBUG <> Invalid) And (m.DEBUG = True)) Then

        com_rostreamer_debug_Debug("ResolveRelativeLinks() baseUrl = [" + baseUrl + "]")

    End If

    ' base document url http://foo.com/bar/test.txt ==> http://foo.com/bar/
    baseDocumentUrl = p_url

    While com_rostreamer_string_EndsWith(baseDocumentUrl, "/") = False

        baseDocumentUrl = Left(baseDocumentUrl, Len(baseDocumentUrl) - 1)

    End While

    If com_rostreamer_string_EndsWith(baseDocumentUrl, "/") = True Then

        baseDocumentUrl = Left(baseDocumentUrl, Len(baseDocumentUrl) - 1)

    End If

    If ((m.DEBUG <> Invalid) And (m.DEBUG = True)) Then

        com_rostreamer_debug_Debug("ResolveRelativeLinks() baseDocumentUrl = [" + baseDocumentUrl + "]")

    End If

    For i = 0 To (p_contentMetaData.Count() - 1)

        If p_contentMetaData[i].title <> invalid Then

            p_contentMetaData[i].title = com_rostreamer_url_Unescape(p_contentMetaData[i].title)

        End If

        If p_contentMetaData[i].shortdescriptionline1 <> invalid Then

            p_contentMetaData[i].shortdescriptionline1 = com_rostreamer_url_Unescape(p_contentMetaData[i].shortdescriptionline1)

        End If

        If p_contentMetaData[i].shortdescriptionline2 <> invalid Then

            p_contentMetaData[i].shortdescriptionline2 = com_rostreamer_url_Unescape(p_contentMetaData[i].shortdescriptionline2)

        End If

        If p_contentMetaData[i].description <> invalid Then

            p_contentMetaData[i].description = com_rostreamer_url_Unescape(p_contentMetaData[i].description)

        End If

        If p_contentMetaData[i].hdposterurl <> invalid Then

            p_contentMetaData[i].hdposterurl = MakeAbsoluteUrl(baseUrl, baseDocumentUrl, p_contentMetaData[i].hdposterurl, p_defaultFile)
            p_contentMetaData[i].hdposterurl = com_rostreamer_string_ReplaceAll(p_contentMetaData[i].hdposterurl, " ", "%20")


        End If

        If p_contentMetaData[i].sdposterurl <> invalid Then

            p_contentMetaData[i].sdposterurl = MakeAbsoluteUrl(baseUrl, baseDocumentUrl, p_contentMetaData[i].sdposterurl, p_defaultFile)
            p_contentMetaData[i].sdposterurl = com_rostreamer_string_ReplaceAll(p_contentMetaData[i].sdposterurl, " ", "%20")

        End If

        If p_contentMetaData[i].jsonfeedurl <> invalid Then

            p_contentMetaData[i].jsonfeedurl = MakeAbsoluteUrl(baseUrl, baseDocumentUrl, p_contentMetaData[i].jsonfeedurl, p_defaultFile)
            p_contentMetaData[i].jsonfeedurl = com_rostreamer_string_ReplaceAll(p_contentMetaData[i].jsonfeedurl, " ", "%20")

        End If

        If p_contentMetaData[i].streamurls <> invalid Then

            For j = 0 To (p_contentMetaData[i].streamurls.Count() - 1)

                p_contentMetaData[i].streamurls[j] = MakeAbsoluteUrl(baseUrl, baseDocumentUrl, p_contentMetaData[i].streamurls[j], p_defaultFile)
                p_contentMetaData[i].streamurls[j] = com_rostreamer_string_ReplaceAll(p_contentMetaData[i].streamurls[j], " ", "%20")

            End For

        End If

    End For

    return p_contentMetaData

End Function

'
' Function to change a relative URL into an absolute URL
'
Function MakeAbsoluteUrl(p_base_url As String, p_base_document_url, p_url As String, p_base_document As String) As String

    If ((m.DEBUG <> Invalid) And (m.DEBUG = True)) Then

        com_rostreamer_debug_Debug("MakeAbsoluteUrl() p_base_url = [" + p_base_url + "]")
        com_rostreamer_debug_Debug("MakeAbsoluteUrl() p_base_document_url = [" + p_base_document_url + "]")
        com_rostreamer_debug_Debug("MakeAbsoluteUrl() p_url = [" + p_url + "]")
        com_rostreamer_debug_Debug("MakeAbsoluteUrl() p_base_document = [" + p_base_document + "]")

    End If

    If com_rostreamer_string_StartsWith(LCase(p_url), "http://") Then

        result = p_url

    Else If com_rostreamer_string_StartsWith(p_url, "/") Then

        result = p_base_url + p_url

    Else

        result = p_base_document_url + "/" + p_url

    End If

    If com_rostreamer_string_EndsWith(result, "/") Then

        result = result + p_base_document

    End If

    If ((m.DEBUG <> Invalid) And (m.DEBUG = True)) Then

        com_rostreamer_debug_Debug("MakeAbsoluteUrl() result = [" + result + "]")

    End If

    return result

End Function