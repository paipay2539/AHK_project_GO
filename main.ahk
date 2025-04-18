﻿;######################## ตั้งค่าเริ่มต้น ########################
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
