;######################## ตั้งค่าเริ่มต้น ########################
#NoEnv
#KeyHistory 0
#Persistent
#MaxThreadsPerHotkey 1
CoordMode, ToolTip, Client

#Include %A_ScriptDir%\define.ahk
#Include %A_ScriptDir%\loop.ahk
#Include %A_ScriptDir%\functions.ahk
#Include %A_ScriptDir%\movement.ahk

;######################## F1 ดูตำแหน่งเมาส์ ########################
F1::
    MouseGetPos, mouseX, mouseY
    PixelGetColor, color, %mouseX%, %mouseY%
    Clipboard := "Position: (" mouseX ", " mouseY ") Color: " color
Return

;######################## รีโหลด ########################
F2::
UpAllKeys()
Reload
Return

;######################## Debug ########################
F3::movementJugde("upup")
    ; ดึงขนาดหน้าจอ
    SysGet, screenWidth, 78
    SysGet, screenHeight, 79

    ; คำนวณตำแหน่งกลางจอ
    centerX := screenWidth // 2
    centerY := screenHeight // 2

    ; แสดง ToolTip กลางจอ
    ToolTip, %color%, %centerX%, %centerY%
    Sleep, 1000 ; แสดง ToolTip เป็นเวลา 2 วินาที
    ToolTip ; ซ่อน ToolTip
Return
F4::
    global config
    for index, position in config.targetPosition {
        MouseMove, position.x, position.y, 0 ; ย้ายเมาส์ไปยังตำแหน่ง (x, y) โดยไม่มีการหน่วงเวลา
        Sleep, 500 ; หยุดที่ตำแหน่งนี้เป็นเวลา 0.5 วินาที (500 มิลลิวินาที)
    }
Return

;######################## Get position ########################
~F5::
    global targetPositions
    if !IsObject(targetPositions) ; ตรวจสอบว่าตัวแปร targetPositions ถูกสร้างหรือยัง
        targetPositions := [] ; สร้าง array ถ้ายังไม่มี

    ; ดึงตำแหน่งเมาส์ปัจจุบัน
    MouseGetPos, mouseX, mouseY
    mouseY:= mouseY - 5 ; offset character icon
    ; เพิ่มตำแหน่งใหม่เข้าไปใน array
    targetPositions.Push({x: mouseX, y: mouseY})

    ; สร้างข้อความสำหรับคลิปบอร์ด
    clipboardText := "config.targetPosition := ["
    for index, position in targetPositions {
        clipboardText .= "{x: " position.x ", y: " position.y "}"
        if (index < targetPositions.MaxIndex()) ; เพิ่มเครื่องหมาย ',' ถ้าไม่ใช่ตำแหน่งสุดท้าย
            clipboardText .= ","
    }
    clipboardText .= "]"

    ; อัปเดตข้อความในคลิปบอร์ด
    Clipboard := clipboardText
Return
F6::
    global targetPositions
    if !IsObject(targetPositions) ; ตรวจสอบว่าตัวแปร targetPositions ถูกสร้างหรือยัง
        targetPositions := [] ; สร้าง array ถ้ายังไม่มี

    global config
    PixelSearch, mouseX, mouseY, config.miniMapWindow.x1, config.miniMapWindow.y1, config.miniMapWindow.x2, config.miniMapWindow.y2, config.miniMapWindow.color, 0, fast
    ; เพิ่มตำแหน่งใหม่เข้าไปใน array
    targetPositions.Push({x: mouseX, y: mouseY})

    ; สร้างข้อความสำหรับคลิปบอร์ด
    clipboardText := "config.targetPosition := ["
    for index, position in targetPositions {
        clipboardText .= "{x: " position.x ", y: " position.y "}"
        if (index < targetPositions.MaxIndex()) ; เพิ่มเครื่องหมาย ',' ถ้าไม่ใช่ตำแหน่งสุดท้าย
            clipboardText .= ","
    }
    clipboardText .= "]"

    ; อัปเดตข้อความในคลิปบอร์ด
    Clipboard := clipboardText
Return
;######################## ออกจากโปรแกรม ########################
F12::
UpAllKeys()
ExitApp

;######################## เปิด/ปิด loop ด้วย Space ########################
~XButton1::global moveEnable := 0
~XButton2::global moveEnable := 1
~Space::
    global config, active, moveEnable
    SetEnglishLayout()

    for index, skill in config.skill
    {
        PixelGetColor, newColor, skill.x, skill.y
        skill.color := newColor
    }
    active := !active
    if active {
        Sleep, 100
        SetTimer, buffLoop, 60000, -1
        SetTimer, humanCheckLoop, 10000, -2 
        SetTimer, restoreLoop, 100, -3
        SetTimer, masterLoop, 10, -4
    } else {
        SetTimer, buffLoop, Off
        SetTimer, humanCheckLoop, Off
        SetTimer, restoreLoop, Off
        SetTimer, masterLoop, Off
    }
Return

Up:: 
Critical, On
SendInput, {control up} ; ยก Control ขึ้น
pressKeyFunction("up")
Return

Down:: 
Critical, On
SendInput, {control up} ; ยก Control ขึ้น
pressKeyFunction("down")
Return


