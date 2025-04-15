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

; ########################## Open-loop position control #########################
openLoopNavigate() {
    global config
    static movePattern := ["left", "upup", "right", "right", "down", "superup"]
    ;static movePattern := ["left", "right", "right", "left"]
    static index := 0
    index := Mod(index, movePattern.MaxIndex()) + 1
    movementJugde(movePattern[index])
}

; ########################## Closed-loop position control #########################
navigateToTarget(currentX, currentY, targetX, targetY) {
    global config

    ; ดึงค่าจาก config.movementThreshold
    arrivedDistX := config.movementThreshold.arrivedDistX
    arrivedDistY := config.movementThreshold.arrivedDistY
    superupDistY := config.movementThreshold.superupDistY
    upupDistY := config.movementThreshold.upupDistY
    upDistY := config.movementThreshold.upDistY
    moveGainX := config.movementThreshold.moveGainX

    ; คำนวณระยะห่างในแกน X และ Y
    deltaX := targetX - currentX
    deltaY := (targetY - currentY) * -1 ; เปลี่ยนสัญญาณ Y ให้เป็นบวก

    ; ตรวจสอบแกน X ก่อน
    if (Abs(deltaX) > arrivedDistX) {
        ; คำนวณเวลาในการกดปุ่มแกน X
        holdTime := Abs(deltaX) * moveGainX
        holdTime := Floor(holdTime) ; ทำให้เป็นจำนวนเต็ม

        if (deltaX > 0) {
            movementJugde("right", holdTime) ; ถ้าอยู่ซ้ายของเป้าหมาย ออกคำสั่ง right พร้อมเวลา
        } else {
            movementJugde("left", holdTime) ; ถ้าอยู่ขวาของเป้าหมาย ออกคำสั่ง left พร้อมเวลา
        }
        Return false ; ออกคำสั่งแล้วหยุดการทำงาน
    }

    ; ตรวจสอบแกน Y
    if (Abs(deltaY) > arrivedDistY) {
        if (deltaY > 0) {
            ; ถ้าแกน Y ต่ำกว่าเป้าหมาย
            if (deltaY > superupDistY) {
                movementJugde("superup") ; ห่างมากกว่า superupDistY ออกคำสั่ง superup
            } else if (deltaY > upupDistY) {
                movementJugde("upup") ; ห่างมากกว่า upupDistY ออกคำสั่ง upup
            } else {
                movementJugde("up") ; ห่างมากกว่า upDistY ออกคำสั่ง up
            }
        } else {
            ; ถ้าแกน Y สูงกว่าเป้าหมาย
            movementJugde("down") ; ออกคำสั่ง down
        }
        Return false ; ออกคำสั่งแล้วหยุดการทำงาน
    }

    ; ถ้าทั้งแกน X และ Y อยู่ในระยะที่ถือว่าถึงเป้าหมายแล้ว
    Return true ; ถึงเป้าหมายแล้ว
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

closedLoopNavigate() {
    global config
    static targetIndex := 1 ; เริ่มต้นที่เป้าหมายแรกใน config.targetPosition

    ; ดึงตำแหน่งปัจจุบัน
    if (!currentPosition(currentX, currentY)) {
        pressKeyFunction("+")
        ToolTip, กดเปิดมินิแมพที
        Sleep, 1000 ; แสดง ToolTip เป็นเวลา 2 วินาที
        ToolTip ; ซ่อน ToolTip
        Return
    }

    ; ดึงตำแหน่งเป้าหมายปัจจุบัน
    targetX := config.targetPosition[targetIndex].x
    targetY := config.targetPosition[targetIndex].y
    
    ; For debug
    ; MouseGetPos, targetX, targetY

    ; เรียกใช้ navigateToTarget และตรวจสอบว่าถึงเป้าหมายแล้วหรือยัง
    if (navigateToTarget(currentX, currentY, targetX, targetY)) {
        ; หากถึงเป้าหมายแล้ว ให้เปลี่ยนไปยังเป้าหมายถัดไป
        targetIndex := Mod(targetIndex, config.targetPosition.MaxIndex()) + 1
    }
}
