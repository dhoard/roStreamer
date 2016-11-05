'
' Function to create a base (emtpy image) screen
'
Function com_rostreamer_screen_CreateBaseScreen()

    imageCanvas = CreateObject("roImageCanvas")
    imageCanvas.SetMessagePort(CreateObject("roMessagePort"))
    imageCanvas.SetLayer(0, { color : "#000000" })

    return imageCanvas

End Function

'
' Function to create a logo screen
'
Function com_rostreamer_screen_CreateLogoScreen(p_hdImageUrl As String, p_sdImageUrl As String)

    imageCanvas = CreateObject("roImageCanvas")
    imageCanvas.SetMessagePort(CreateObject("roMessagePort"))
    imageCanvas.SetRequireAllImagesToDraw(True)

    If com_rostreamer_device_IsHd() = True Then

        imageCanvas.SetLayer(0, { url : p_hdImageUrl, targetRect: { x : 0, y : 0, w : 1280, h : 720 } })

    Else

        imageCanvas.SetLayer(0, { url : p_sdImageUrl, targetRect: { x : 0, y : 0, w : 720, h : 480 } })

    End If

    return imageCanvas

End Function

'
' Function to create a simple text screen
'
Function com_rostreamer_screen_CreateTextScreen(p_message As String) As Object

    imageCanvas = CreateObject("roImageCanvas")
    imageCanvas.SetMessagePort(CreateObject("roMessagePort"))

    imageCanvas.SetLayer(0, [ { color : "#000000" }, { text : p_message, textAttrs : { color : "#FFFFFF" } } ])

    If com_rostreamer_device_IsHd() Then

        imageCanvas.SetLayer(1, { url : "pkg:/images/Overhang_Background_HD.png", targetRect: { x : 0, y : 0, w : 1280, h : 140 } })

    Else

        imageCanvas.SetLayer(1, { url : "pkg:/images/Overhang_Background_SD.png", targetRect: { x : 0, y : 0, w : 720, h : 93 } })

    End If

    return imageCanvas

End Function

'
' Function to create a flat-category poster screen
'
Function com_rostreamer_screen_CreateFlatCategoryPosterScreen() As Object

    posterScreen = CreateObject("roPosterScreen")
    posterScreen.SetMessagePort(CreateObject("roMessagePort"))
    posterScreen.SetListStyle("flat-category")
    posterScreen.SetListDisplayMode("scale-to-fit")
    'posterScreen.SetCertificatesFile("pkg:/certs/RootCA.crt")
    posterScreen.AddHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3")

    return posterScreen

End Function

'
' Function to show an error sceen
'
Sub com_rostreamer_screen_ShowErrorScreen(p_message As String)

    errorScreen = com_rostreamer_screen_CreateTextScreen(p_message)
    errorScreen.Show()

    wait(5000, errorScreen.GetMessagePort())

    errorScreen.Close()

End Sub