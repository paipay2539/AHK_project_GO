movementJugde(movePattern, horizontalHoldTime := 400, verticalHoldTime := 400) {
    ; ตรวจสอบว่า movePattern เป็นค่าที่กำหนดไว้หรือไม่
    if !(movePattern in "up|upup|superup|down|left|right")
        Return ; หากไม่ใช่ค่า "up", "upup", "down", "left", "right", หรือ "superup" ให้ return ทันที

    ; หากเป็น "down" ให้กด Ctrl ค้างไว้ก่อน แล้วทำงาน
    if (movePattern = "down") {
        SendInput, {Ctrl down} ; กด Ctrl ค้างไว้
        pressKeyFunction(movePattern) ; กดปุ่ม "down"
        SendInput, {Ctrl up} ; ปล่อย Ctrl
    } 
    ; หากเป็น "up"
    else if (movePattern = "up") {
        pressKeyFunction("up") ; กดปุ่ม "up"
    } 
    ; หากเป็น "upup"
    else if (movePattern = "upup") {
        pressKeyFunction("up", verticalHoldTime) ; กดปุ่ม "up"
        pressKeyFunction("up")
    } 
    ; หากเป็น "superup"
    else if (movePattern = "superup") {
        SendInput, {Ctrl down} ; กด Ctrl ค้างไว้
        pressKeyFunction("up", verticalHoldTime) ; กดปุ่ม "up"
        SendInput, {Ctrl up} ; ปล่อย Ctrl
    }
    ; หากเป็น "left" หรือ "right"
    else {
        pressKeyFunction(movePattern, horizontalHoldTime) ; กดปุ่ม "left" หรือ "right"
    }
}

currentPosition(ByRef x, ByRef y) {
    global config
    PixelSearch, x, y, config.miniMapWindow.x1, config.miniMapWindow.y1, config.miniMapWindow.x2, config.miniMapWindow.y2, config.miniMapWindow.color, 0, fast
    if (ErrorLevel = 0) {
        Return true ; คืนค่า true หากพบพิกเซล
    } else {
        debegBeep2()
        Return false ; คืนค่า false หากไม่พบพิกเซล
    }
}

