skillLoop() {
    global config
    IfWinNotActive, % config.windowName
        Return
    ;######################### single thread method #########################
    static count := 0
    count := Mod(count, 4) + 1 ; นับ 1 ถึง 4 แล้ววนกลับมา 1
    checkCooldown(config.skill[count].key, config.skill[count].color, config.skill[count].x, config.skill[count].y)
}

restoreLoop() {
    global config
    IfWinNotActive, % config.windowName
        Return

    for index, restore in config.restore
    {
        PixelGetColor, restoreColor, restore.x, restore.y
        if (restoreColor != restore.color)
            pressKeyFunction(restore.key)
    }
}

qqCheckLoop() {
    global config
    IfWinNotActive, % config.windowName
        Return

    confirmX := config.confirm.x
    confirmY := config.confirm.y
    confirmColor := config.confirm.color

    PixelGetColor, mainloopColor, confirmX, confirmY
    if (mainloopColor = confirmColor)
    {
        Click, %confirmX%, %confirmY%
        Sleep, 500
        Click, %confirmX%, %confirmY%
        Sleep, 100
        Click, %confirmX% * 1.5, %confirmY%
    }
}

pickItemLoop() {
    global config
    IfWinNotActive, % config.windowName
        Return
    pressKeyFunction("control", 25)
}

MoveLoop() {
    global config
    IfWinNotActive, % config.windowName
        Return
    if (checkAnyKeyPress() = 0)
    {
        static movePattern := ["left", "right", "right", "left"]
        static index := 0
        index := Mod(index, movePattern.MaxIndex()) + 1
        pressKeyFunction(movePattern[index], 400)
    }
    else {
        SendInput, {control up}
    }
}

buffLoop() {
    global config
    IfWinNotActive, % config.windowName
        Return
    Loop, 6
    {
        pressKeyFunction("v", 50)
    }
}

humanCheckLoop() {
    global pixelCheck, config
    PixelSearch, foundX, foundY, pixelCheck.x1, pixelCheck.y1, pixelCheck.x2, pixelCheck.y2, pixelCheck.color, 0, fast
    if (ErrorLevel = 0)
    {
        SoundBeep, 2000, 100
        SoundBeep, 2500, 100
        SoundBeep, 3000, 100
    }
}

masterLoop() {
    Loop, 8
    {
        skillLoop()
        pickItemLoop()
    }
    qqCheckLoop()

    global moveEnable
    if (moveEnable) 
    {  
        MoveLoop()
    }
}