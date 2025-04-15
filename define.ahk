;######################## ตัวแปร ########################
config := Object()
config.skill := []
config.skill.push(Object("x", 800, "y", 1000, "color", "0xF3D0CC", "key", 1))
config.skill.push(Object("x", 840, "y", 1000, "color", "0xF3D0CC", "key", 2))
config.skill.push(Object("x", 880, "y", 1000, "color", "0xF3D0CC", "key", 3))
config.skill.push(Object("x", 920, "y", 1000, "color", "0xF3D0CC", "key", 4))

config.restore := []
config.restore.push(Object("x", 170, "y", 11, "color", "0x0000FF", "key", 5))
config.restore.push(Object("x", 170, "y", 26, "color", "0xFFBD08", "key", 6))

config.confirm := Object("x", 333, "y", 473, "color", "0x299CFF")
config.miniMapWindow := Object("x1", 1400, "y1", 100, "x2", 1900, "y2", 350, "color", "0x00E7FF")
config.pixelCheck := Object("color", 0x0000F7, "x1", 1700, "y1", 40, "x2", 1900, "y2", 150)
config.afterSkillDelay := 800
config.windowName := "GhostOnline"

config.targetPosition := [{x: 1517, y: 264},{x: 1583, y: 280},{x: 1655, y: 265},{x: 1740, y: 280}]
config.movementThreshold := Object()
config.movementThreshold["arrivedDistX"] := 8  ; ระยะที่ถือว่า ถึงเป้าหมายในแกน X
config.movementThreshold["arrivedDistY"] := 6  ; ระยะที่ถือว่า ถึงเป้าหมายในแกน Y
config.movementThreshold["superupDistY"] := 18  ; ระยะที่ต้องใช้คำสั่ง superup
config.movementThreshold["upupDistY"] := 10     ; ระยะที่ต้องใช้คำสั่ง upup
config.movementThreshold["moveGainX"] := 27     ; Gain สำหรับการเคลื่อนที่ในแกน X

skillAct := 1
active := false

SetEnglishLayout() {
    hwnd := WinActive("A")
    ; 0x50 is WM_INPUTLANGCHANGEREQUEST
    PostMessage, 0x50, 0, 0x04090409,, ahk_id %hwnd%
}

debegBeep1() {
    SoundBeep, 2000, 100
    SoundBeep, 2500, 100
    SoundBeep, 3000, 100
}

debegBeep2() {
    SoundBeep, 3000, 100
    SoundBeep, 3500, 100
    SoundBeep, 4000, 100
}