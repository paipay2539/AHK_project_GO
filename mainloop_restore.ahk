mainloop:
    global config
    for index, skill in config.skill
    {
        checkCooldown(skill.key, skill.color, skill.x, skill.y)
    }

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
        Click, 500, 471
    }
Return

restoreTask:
    global config
    IfWinNotActive, GhostOnline
        Return

    for index, restore in config.restore
    {
        PixelGetColor, restoreColor, restore.x, restore.y
        if (restoreColor != restore.color)
            pressKeyFunction(restore.key)
    }
Return