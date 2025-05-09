checkAnyKeyPress()
{
    GetKeyState, keyPressUp, Up
    GetKeyState, keyPressDown, Down
    GetKeyState, keyPressRight, Right
    GetKeyState, keyPressLeft, Left
    GetKeyState, keyPress1, Space
    GetKeyState, keyPress2, Control
    GetKeyState, keyPressV, V
    GetKeyState, keyPressB, B
    GetKeyState, keyPressN, N
    return (keyPressUp = "D" || keyPressDown = "D" || keyPressRight = "D" || keyPressLeft = "D" || keyPress1 = "D" || keyPress2 = "D" || keyPressV = "D" || keyPressB = "D" || keyPressN = "D") ? 1 : 0
}

pressKeyFunction(buttonTarget, holdTime := 100, cooldownTime := 10)
{
    SendInput, {%buttonTarget% down}
    Sleep, %holdTime%
    SendInput, {%buttonTarget% up}
    Sleep, %cooldownTime%
}

checkCooldown(targetKey, checkColor, checkPointX, checkPointY)
{
    global skillAct
    if (checkAnyKeyPress() = 0 && skillAct = 1)
    {
        PixelGetColor, color, checkPointX, checkPointY
        if (color = checkColor)
        {
            retryCounter := 0
            Loop {
                pressKeyFunction(targetKey)
                retryCounter++
                PixelGetColor, color, checkPointX, checkPointY
                if (color != checkColor || retryCounter > 10)
                    Break
            }
        }
    }
    else
    {
        SendInput, {control up}
    }
}

UpAllKeys()
{
    clipboard := ""
    Loop, 0xFF
    {
        Key := Format("VK{:02X}", A_Index)
        If GetKeyState(Key)
            Send, {%Key% Up}
    }
}