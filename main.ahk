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
CoordMode, ToolTip, Client   ; ใช้พิกัดแบบ Client
OnExit, ExitSub              ; ฟังก์ชันเมื่อออกจากโปรแกรม

;######################## ตัวแปร ########################
setPointArrayX := []
setPointArrayY := []
arrayCount := 0
setPointCount := 0

targetColor := 0xF3D0CC   ; สีเป้าหมาย
skillAct := 1             ; เปิดใช้การกดสกิล

Return

;######################## กด F1 เพื่อดูตำแหน่งเมาส์และสี ########################
F1::
    MouseGetPos, mouseX, mouseY
    PixelGetColor, color, %mouseX%, %mouseY%
    Clipboard := "Position: (" mouseX ", " mouseY ") Color: " color
Return

;######################## กด F3 เพื่อดูสีจากตำแหน่งล่าสุด ########################
F3::
    PixelGetColor, color, %mouseX%, %mouseY%
    Clipboard := "Position: (" mouseX ", " mouseY ") Color: " color
Return

;######################## แสดง ToolTip ทดสอบ ########################
F5::
    ShowToolTip("aaaa", 313, 540)
Return

;######################## รีโหลดสคริปต์ ########################
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

;######################## สลับเปิด/ปิด Loop เมื่อกด Space ########################
~space::
    PixelGetColor, color1, 800, 1000
    PixelGetColor, color2, 840, 1000
    PixelGetColor, color3, 880, 1000
    PixelGetColor, color4, 920, 1000

    active := !active

    if active {
        Sleep, 100
        SetTimer, mainloop, 100, -2
        SetTimer, restoreTask, 100, -1
    } else {
        SetTimer, mainloop, Off
        SetTimer, restoreTask, Off
    }
Return

;######################## ฟังก์ชันแสดง ToolTip ########################
ShowToolTip(text, x, y) {
    ToolTip, %text%, %x%, %y%
}

;######################## Main loop ตรวจสอบการใช้งาน skill ########################
mainloop:
    checkCooldown(1, color1, 800, 1000)
    checkCooldown(2, color2, 840, 1000)
    checkCooldown(3, color3, 880, 1000)   
    checkCooldown(4, color4, 920, 1000)

    PixelGetColor, mainloopColor, 333, 473  ; ตรวจสีเพื่อคลิกยืนยัน
    if (mainloopColor = 0x299CFF)
    {
        Click, 333, 473
        Sleep, 500
        Click, 333, 473
        Sleep, 100
        Click, 500, 471
    }
Return

;######################## ตรวจสอบและกดปุ่มฟื้นพลังอัตโนมัติ ########################
restoreTask:
    IfWinNotActive, GhostOnline
        Return

    PixelGetColor, restoreColor, 170, 11
    if (restoreColor != 0x0000FF)
        pressKeyFunction(5)

    PixelGetColor, restoreColor, 170, 26
    if (restoreColor != 0xFFBD08)
        pressKeyFunction(6)
Return

;######################## ตรวจว่าผู้เล่นกดปุ่มเดินหรือปุ่มอื่นอยู่หรือไม่ ########################
checkAnyKeyPress:
    GetKeyState, keyPressUp, Up
    GetKeyState, keyPressDown, Down
    GetKeyState, keyPressRight, Right
    GetKeyState, keyPressLeft, Left
    GetKeyState, keyPress1, Space
    GetKeyState, keyPress2, Control

    anyKeyPress := (keyPressUp = "D" || keyPressDown = "D" || keyPressRight = "D" || keyPressLeft = "D" || keyPress1 = "D" || keyPress2 = "D") ? 1 : 0
Return

;######################## ฟังก์ชันกดปุ่มตามที่กำหนด ########################
pressKeyFunction(buttonTarget, holdTime := 100, cooldownTime := 10) {
    SendInput, {%buttonTarget% down}
    Sleep, %holdTime%
    SendInput, {%buttonTarget% up}
    Sleep, %cooldownTime%
    Return
}

;######################## ตรวจสอบคูลดาวน์สกิลและกดใช้ ########################
checkCooldown(targetKey, checkColor, checkPointX, checkPointY) {
    gosub checkAnyKeyPress
    Global anyKeyPress, skillAct

    if (anyKeyPress = 0 && skillAct = 1)
    {
        PixelGetColor, color, checkPointX, checkPointY
        if (color = checkColor)
        {
            retryCounter := 0
            Loop {
                pressKeyFunction(targetKey)
                retryCounter++
                pressKeyFunction("control")
                PixelGetColor, color, checkPointX, checkPointY
                if (color != checkColor || retryCounter > 10)
                    Break
            }
        }
    }
Return
}