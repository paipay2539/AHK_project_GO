#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0

;######################## ตั้งค่าเริ่มต้น ########################
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1

#Persistent
#MaxThreadsPerHotkey 3
CoordMode, ToolTip, Client
OnExit, ExitSub

;######################## ตัวแปร ########################
config := Object()
config.skill := []
config.skill.push(Object("x", 800, "y", 1000, "color", 0xF3D0CC, "key", 1))
config.skill.push(Object("x", 840, "y", 1000, "color", 0xF3D0CC, "key", 2))
config.skill.push(Object("x", 880, "y", 1000, "color", 0xF3D0CC, "key", 3))
config.skill.push(Object("x", 920, "y", 1000, "color", 0xF3D0CC, "key", 4))

config.confirm := Object("x", 333, "y", 473, "color", 0x299CFF)

config.restore := []
config.restore.push(Object("x", 170, "y", 11, "color", 0x0000FF, "key", 5))
config.restore.push(Object("x", 170, "y", 26, "color", 0xFFBD08, "key", 6))

skillAct := 1
Return

;######################## F1 ดูตำแหน่งเมาส์ ########################
F1::
    MouseGetPos, mouseX, mouseY
    PixelGetColor, color, %mouseX%, %mouseY%, RGB
    Clipboard := "Position: (" mouseX ", " mouseY ") Color: " color
Return

;######################## รีโหลด ########################
F2::Reload
~-::Reload

;######################## ออกจากโปรแกรม ########################
F12::ExitApp

ExitSub:
    clipboard := ""
    Loop, 0xFF
    {
        Key := Format("VK{:02X}", A_Index)
        If GetKeyState(Key)
            Send, {%Key% Up}
    }
ExitApp

;######################## เปิด/ปิด loop ด้วย Space ########################
~Space::
    ; อัปเดต config.skill.color
    for index, skill in config.skill
    {
        PixelGetColor, newColor, skill.x, skill.y, RGB
        skill.color := newColor
    }
    active := !active
    if active {
        Sleep, 100
        SetTimer, mainloop, 100
        SetTimer, restoreTask, 100
    } else {
        SetTimer, mainloop, Off
        SetTimer, restoreTask, Off
    }
Return

;######################## main loop ########################
mainloop:
    for index, skill in config.skill
    {
        checkCooldown(skill.key, skill.color, skill.x, skill.y)
    }

    ; แยกการเข้าถึง config.confirm
    confirmX := config.confirm.x
    confirmY := config.confirm.y
    confirmColor := config.confirm.color

    PixelGetColor, mainloopColor, confirmX, confirmY, RGB
    if (mainloopColor = confirmColor)
    {
        Click, %confirmX%, %confirmY%
        Sleep, 500
        Click, %confirmX%, %confirmY%
        Sleep, 100
        Click, 500, 471
    }
Return

;######################## restore ########################
restoreTask:
    IfWinNotActive, GhostOnline
        Return

    for index, restore in config.restore
    {
        PixelGetColor, restoreColor, restore.x, restore.y, RGB
        if (restoreColor != restore.color)
            pressKeyFunction(restore.key)
    }
Return

;######################## ตรวจปุ่ม ########################
checkAnyKeyPress:
    GetKeyState, keyPressUp, Up
    GetKeyState, keyPressDown, Down
    GetKeyState, keyPressRight, Right
    GetKeyState, keyPressLeft, Left
    GetKeyState, keyPress1, Space
    GetKeyState, keyPress2, Control

    anyKeyPress := (keyPressUp = "D" || keyPressDown = "D" || keyPressRight = "D" || keyPressLeft = "D" || keyPress1 = "D" || keyPress2 = "D") ? 1 : 0
Return

;######################## กดปุ่ม ########################
pressKeyFunction(buttonTarget, holdTime := 100, cooldownTime := 10)
{
    SendInput, {%buttonTarget% down}
    Sleep, %holdTime%
    SendInput, {%buttonTarget% up}
    Sleep, %cooldownTime%
    Return
}

;######################## ตรวจ cooldown skill ########################
checkCooldown(targetKey, checkColor, checkPointX, checkPointY)
{
    gosub checkAnyKeyPress
    global anyKeyPress, skillAct

    if (anyKeyPress = 0 && skillAct = 1)
    {
        PixelGetColor, color, checkPointX, checkPointY, RGB
        if (color = checkColor)
        {
            retryCounter := 0
            Loop {
                pressKeyFunction(targetKey)
                retryCounter++
                pressKeyFunction("control")
                PixelGetColor, color, checkPointX, checkPointY, RGB
                if (color != checkColor || retryCounter > 10)
                    Break
            }
        }
    }
Return
}
