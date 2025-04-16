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
    confirmX2 := config.confirm.x + 1000
    confirmY := config.confirm.y
    confirmColor := config.confirm.color

    PixelGetColor, mainloopColor, confirmX, confirmY
    if (mainloopColor = confirmColor)
    {
        Click, %confirmX%, %confirmY%
        Sleep, 500
        Click, %confirmX%, %confirmY%
        Sleep, 100
        Click, %confirmX2%, %confirmY%
    }
}

pickItemLoop() {
    global config
    IfWinNotActive, % config.windowName
        Return
    pressKeyFunction("control", 25)
    pressKeyFunction("control", 25)
    pressKeyFunction("control", 25)
    pressKeyFunction("control", 25)
    pressKeyFunction("control", 25)
    pressKeyFunction("control", 25)
}

moveLoop() {
    global config
    IfWinNotActive, % config.windowName
        Return
    if (checkAnyKeyPress() = 0)
    {
        ;Sleep, % config.afterSkillDelay
        ;openLoopNavigate()
        closedLoopNavigate()
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
    global config
    PixelSearch, foundX, foundY, config.pixelCheck.x1, config.pixelCheck.y1, config.pixelCheck.x2, config.pixelCheck.y2, config.pixelCheck.color, 0, fast
    if (ErrorLevel = 0)
    {
        debegBeep1()
    }
}

masterLoop() {
    Loop, 3
    {
        skillLoop()
        pickItemLoop()
    }
    qqCheckLoop()

    global moveEnable
    if (!moveEnable) 
    {  
        moveLoop()
    }
}