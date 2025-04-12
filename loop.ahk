skillLoop() {
    global config
    IfWinNotActive, GhostOnline
        Return
    ;######################### sigle thread method #########################
    static count := 0
    count := Mod(count, 4) + 1 ; นับ 1 ถึง 4 แล้ววนกลับมา 1
    checkCooldown(config.skill[count].key, config.skill[count].color, config.skill[count].x, config.skill[count].y)
    ;######################### multi-thread method #########################
    /* 
    for index, skill in config.skill
    {
        checkCooldown(skill.key, skill.color, skill.x, skill.y)
    }
    */
}

restoreLoop() {
    global config
    IfWinNotActive, GhostOnline
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
    IfWinNotActive, GhostOnline
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
    IfWinNotActive, GhostOnline
        Return
    pressKeyFunction("control")
    pressKeyFunction("control")
    pressKeyFunction("control")
    pressKeyFunction("control")
    pressKeyFunction("control")
    pressKeyFunction("control")
}

MoveLoop() {
    global config
    IfWinNotActive, GhostOnline
        Return

    static movePattern := ["left", "left", "left", "left", "left", "right", "right", "right", "right", "right"]
    static index := 0
    index := Mod(index, movePattern.MaxIndex()) + 1
    pressKeyFunction(movePattern[index],500)
}

masterLoop() {
    skillLoop()
    skillLoop()
    qqCheckLoop()
    pickItemLoop()
    MoveLoop()
    /*
    static count := 0
    count++
    ;lowFreqTask()
    if (Mod(count, 1) = 0)
        skillLoop()
    ;midFreqTask()    
    if (Mod(count, 2) = 0)
        skillLoop()
    */
}