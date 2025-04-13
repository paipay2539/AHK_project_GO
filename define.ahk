;######################## ตัวแปร ########################
config := Object()
config.skill := []
config.skill.push(Object("x", 800, "y", 1000, "color", "0xF3D0CC", "key", 1))
config.skill.push(Object("x", 840, "y", 1000, "color", "0xF3D0CC", "key", 2))
config.skill.push(Object("x", 880, "y", 1000, "color", "0xF3D0CC", "key", 3))
config.skill.push(Object("x", 920, "y", 1000, "color", "0xF3D0CC", "key", 4))

config.confirm := Object("x", 333, "y", 473, "color", "0x299CFF")

config.restore := []
config.restore.push(Object("x", 170, "y", 11, "color", "0x0000FF", "key", 5))
config.restore.push(Object("x", 170, "y", 26, "color", "0xFFBD08", "key", 6))

pixelCheck := Object("color", 0x0000F7, "x1", 1700, "y1", 40, "x2", 1900, "y2", 150)

skillAct := 1
active := false

SetEnglishLayout() {
    hwnd := WinActive("A")
    ; 0x50 is WM_INPUTLANGCHANGEREQUEST
    PostMessage, 0x50, 0, 0x04090409,, ahk_id %hwnd%
}