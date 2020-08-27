IN_LOOP := false
DEFAULT_SPEED := 2
QUICK_MODE := true
IN_TAB := false
DIRE := "i,j,k,l"


^!l::SwitchMouseKeyboardModel()


#If IN_TAB
		i::
		j::
		k::
		l::
		q::
		s::
		d::
		a::
		Goto, MouseMoveByKey
	Return

	u::ClickLeftMouse()
	
	y::PressMouse()
	
	^u::PressMouseAndCtrl()

	p:: ClickRightMouse()

	h:: MouseWheelUp()

	`;:: MouseWheelDown()
	
	m::ScrollRight()

	n::ScrollLeft()

	b::
	c::
	e::
	f::
	o::
	r::
	t::
	v::
	w::
	x::
	z::
	Return
	
	Esc::SwitchMouseKeyboardModel()
	
#If



MouseMoveByKey:

	global IN_LOOP
	global DEFAULT_SPEED
	global QUICK_MODE

	speed := DEFAULT_SPEED

	If !IN_LOOP
	{

	    IN_LOOP := true
		Loop 100
		{
			
			x_speed := 0
			y_speed := 0
			
			cur_k := ""
			
			If !IN_TAB
				break
			
			If GetKeyState("q", "P")
				QUICK_MODE := true

			If GetKeyState("a","P")
			{
				QUICK_MODE := false
				DEFAULT_SPEED := 2
			}
			
			If GetKeyState("s","P")
			{
				QUICK_MODE := false
				DEFAULT_SPEED := 4
			}
			
			If GetKeyState("d","P")
			{
				QUICK_MODE := false
				DEFAULT_SPEED := 6
			}
		
			; which direction key pressing
			Loop,Parse, DIRE, 
			{
				if GetKeyState(A_LoopField, "P")
					cur_k := A_LoopField
			}
			
		
			; in QUICK_MODE speed overlay every time
			; normally, key press repeatedly mean far away, need quickly
			If cur_k In %DIRE% 
			{
				If ( QUICK_MODE)
					speed := speed + 9
			}
			Else ; or switch to default
			{
				speed := DEFAULT_SPEED
			}
			
			If (cur_k == "l")
			{
			   x_speed := speed
			}

			else If (cur_k == "j")
			{
			
			   x_speed := -speed
			}

			else If (cur_k == "k")
			{

			   y_speed := speed
			}

			else If (cur_k == "i")
			{

			   y_speed := -speed
			}

			x := x_speed
			y := y_speed
			MouseMove, x, y, 0, R

		}
	IN_LOOP := false

	}
Return


Switch2Quick()
{
	global QUICK_MODE
	QUICK_MODE := true
}

SwitchMouseKeyboardModel()
{
	global IN_TAB
	IN_TAB := !IN_TAB
	
	If IN_TAB
		SetSystemCursor()
	Else	
		RestoreSystemCursor()
}


ClickLeftMouse(){
	MouseClick, Left
	; normally, click is the sign of the end of one time mouse move
	; thus, Switch2Quick mode, prepare for next move,
	Switch2Quick()
}

ClickRightMouse()
{
	MouseClick, Right
}

PressMouse(){
	GetKeyState, state, LButton
	If state = D	
		Click, Up
	Else
		Click, Down
}

PressMouseAndCtrl(){
	Send, {CtrlDown}
	MouseClick, Left
	Send, {CtrlUp}
}

MouseWheelUp()
{
	Send, {WheelUp}
}

MouseWheelDown()
{
	Send, {WheelDown}
}

ScrollLeft()
{ 
	ControlGetFocus, mw_control, A
	SendMessage, 0x114, 0, 0, %mw_control%, A
}

ScrollRight(){
	ControlGetFocus, mw_control, A
	SendMessage, 0x114, 1, 0, %mw_control%, A ;0x115 vertical
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



#0::ExitApp