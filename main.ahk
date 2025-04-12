﻿#NoEnv
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

#Include %A_ScriptDir%\define.ahk
#Include %A_ScriptDir%\loop.ahk
#Include %A_ScriptDir%\key_functions.ahk

;######################## F1 ดูตำแหน่งเมาส์ ########################
F1::
    MouseGetPos, mouseX, mouseY
    PixelGetColor, color, %mouseX%, %mouseY%
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
    global config, active
    for index, skill in config.skill
    {
        PixelGetColor, newColor, skill.x, skill.y
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
