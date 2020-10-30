ClickLeftMouse:
	MouseClick, Left
return

ClickRightMouse:

	MouseClick, Right
return

PressMouse:
	GetKeyState, state, LButton
	If state = D	
		Click, Up
	Else
		Click, Down
return 

PressMouseAndCtrl:
	Send, {CtrlDown}
	MouseClick, Left
	Send, {CtrlUp}
return 

MouseWheelUp:

	Send, {WheelUp}
return 

MouseWheelDown:

	Send, {WheelDown}
return

ScrollLeft:

	ControlGetFocus, mw_control, A
	SendMessage, 0x114, 0, 0, %mw_control%, A
return 

ScrollRight:
	ControlGetFocus, mw_control, A
	SendMessage, 0x114, 1, 0, %mw_control%, A ;0x115 vertical
return


WindowMoveLeft:
	WindowMove("LEFT")
return 

WindowMoveRight:
	WindowMove("RIGHT")
return 


WindowMoveUp:
	WindowMove("UP")
return 

WindowMoveDown:
	WindowMove("DOWN")
return 


WindowSizeChangeLeft:
	WindowSizeChange("LEFT")
return 

WindowSizeChangeRight:
	WindowSizeChange("RIGHT")
return 

WindowSizeChangeUp:
	WindowSizeChange("UP")
return 

WindowSizeChangeDown:
	WindowSizeChange("DOWN")
return 

WindowMove(flag="UP"){
	speed := 12
	
	WinGetPos,X,Y,,,A
	if (flag = "UP")
		WinMove,A,,X,Y-speed
	
	else if (flag = "DOWN")
		WinMove,A,,X,Y+speed
	
	else if (flag = "LEFT")
		WinMove,A,,X-speed,Y
	
	else
		WinMove,A,,X+speed,Y
}

WindowSizeChange(flag="UP"){
	; todo let it work
	speed := 15
	WinGetPos, x, y, w, h, A
	if (flag = "UP")
		WinMove,A,,,,w,h-speed
	
	
	else if (flag = "DOWN")
		WinMove,A,,,,w,h+speed
	
	
	else if (flag = "LEFT")
		WinMove,A,,,,w-speed,h
	
	else
		WinMove,A,,,,w+speed,h
}

SetSystemCursor(){
	INI := % A_ScriptDir  "\data\Metro X\Install.inf"
	path := % A_ScriptDir "\data\Metro X\"
	
	;----------Replace Cursor
	Cursors := {    "pointer"      : 32512
				,"help"         : 32651
				,"work"         : 32650
				,"busy"         : 32514
				,"text"         : 32513
				,"unavailiable" : 32648
				,"vert"         : 32645
				,"horz"         : 32644
				,"dgn1"         : 32642
				,"dgn2"         : 32643
				,"move"         : 32646
				,"link"         : 32649
				,"cross"        : 32515
				,"hand"         : 32640
				,"alternate"    : 32516}
	
	CusorFiles := {}
	for i,v in Cursors
	{
		iniread,t,%INI%,Strings,%i%
		CusorFiles[i] := t
		
	}

	
	for i,v in Cursors
	{
		;----------Change Cusror Size
		IMAGE_BITMAP :=0x0
		IMAGE_CURSOR := 0x2
		IMAGE_ICON := 0x1

		; fuFlags:
		LR_COPYFROMRESOURCE := 0x4000
		fn := CusorFiles[i]
		fp := path . fn
		CursorHandle := DllCall( "LoadCursorFromFile", Str,fp)
		
		CursorHandle := DllCall( "CopyImage", uint,CursorHandle, uint,IMAGE_CURSOR, int,CURSOR_W, int,CURSOR_H, uint,0 )

	    DllCall( "SetSystemCursor", Uint,CursorHandle, Int,v)
    }
}

RestoreSystemCursor(){
    SPI_SETCURSORS := 0x57
    DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
    
}

