#SingleInstance
SetDefaultMouseSpeed, 0
DetectHiddenWindows, On
customDPI := A_ScreenDPI/96
hintSize :=  20
winc_presses := 0
numberOfRows := 26
numberOfCols := 26
rowSpacing := hintSize + ( (A_ScreenHeight - numberOfRows * (hintSize * customDPI) ) / (numberOfRows - 1) ) / customDPI
colSpacing := hintSize + ( (A_ScreenWidth - numberOfCols * (hintSize * customDPI) ) / (numberOfCols - 1) ) / customDPI
AscA := 97
KeyArray := ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

Gui, +AlwaysOnTop +ToolWindow -Caption -DPIScale +HwndGrid +LastFound
Gui, Margin, 0
Gui, Color, 779977
Gui, Font, s13 w70 cFFFF00 bold
WinSet, Transparent, 140

; Display Coordinates 
rowCounter := 0
Loop {
	rowYCoord := rowCounter * rowSpacing
	rowYCoordAlpha := KeyArray[rowCounter+1]
	colCounter := 0
	Loop {
		colXCoord := colCounter * colSpacing
		colXCoordAlpha := KeyArray[colCounter+1]
		;Gui, Add, Progress, w%hintSize% h%hintSize% x%colXCoord% y%rowYCoord% Backgroundfafafa disabled
		;gui, add, Pic, w%hintSize% h%hintSize% x%colXCoord% y%rowYCoord% border 0x201 readonly backgroundtrans c212121, %rowYCoordAlpha%%colXCoordAlpha%
		gui, add, Text, w%hintSize% h%hintSize% x%colXCoord% y%rowYCoord% ,  %rowYCoordAlpha%%colXCoordAlpha%
 
		colCounter := colCounter + 1
	} Until colCounter = numberOfcols			
	rowCounter := rowCounter + 1
} Until rowCounter = numberOfRows

Gui -Caption +AlwaysOnTop +E0x20
Gui, Show, Hide X0 Y0 W%A_ScreenWidth% H%A_ScreenHeight%, CoordGrid



INI_PATH = %A_ScriptDir%\Conf.ini

Menu,Tray,NoStandard
Menu,Tray,Icon,images\mouse.ico
Menu,Tray,add,Config(&C),Menu_Ini
Menu,Tray,add
Menu,Tray,add,Restart(&R),Menu_Reload
Menu,Tray,add,Exit(&E),Menu_Exit
Menu,Tray,Click,1

IN_LOOP := false
QUICK_MODE := true
MOUSE_KEYBOARD_MODEL := false
CLICK_KEY := ""

; start hot key config
iniread,TurnOn,%INI_PATH%,Start,SwitchOnOff
iniread,StartWithLocationMode,%INI_PATH%,Start,StartWithLocationMode
Hotkey,%TurnOn%,SwitchMouseKeyboardModel

STARTED := false 

iniread,ExitApp_,%INI_PATH%,Start,ExitApp
if ExitApp_
	Hotkey,%ExitApp_%,ExitApp__


; moves key config,
iniread,DIRE_UP,%INI_PATH%,MouseMove,DIRE_UP
iniread,DIRE_DOWN,%INI_PATH%,MouseMove,DIRE_DOWN
iniread,DIRE_LEFT,%INI_PATH%,MouseMove,DIRE_LEFT
iniread,DIRE_RIGHT,%INI_PATH%,MouseMove,DIRE_RIGHT
DIRE := DIRE_UP "," DIRE_DOWN  "," DIRE_LEFT  ","  DIRE_RIGHT

iniread,QUICK_MODE_KEY,%INI_PATH%,MouseMove,QUICK_MODE_KEY
iniread,LEVEL1_KEY,%INI_PATH%,MouseMove,LEVEL1_KEY
iniread,LEVEL2_KEY,%INI_PATH%,MouseMove,LEVEL2_KEY
iniread,LEVEL3_KEY,%INI_PATH%,MouseMove,LEVEL3_KEY

iniread,LEVEL1,%INI_PATH%,MouseMove,LEVEL1_SPEED
iniread,LEVEL2,%INI_PATH%,MouseMove,LEVEL2_SPEED
iniread,LEVEL3,%INI_PATH%,MouseMove,LEVEL3_SPEED

iniread,DEFAULT_SPEED,%INI_PATH%,MouseMove,DEFAULT_SPEED
iniread,QUICK_MODE_UP_SPEED,%INI_PATH%,MouseMove,QUICK_MODE_UP_SPEED
iniread,NORMAL_MODEL_UP_SPEED,%INI_PATH%,MouseMove,NORMAL_MODEL_UP_SPEED

iniread,TO_LOCATION_MODE,%INI_PATH%,MouseMove,TO_LOCATION_MODE

Hotkey, If, MOUSE_KEYBOARD_MODEL
Hotkey,%DIRE_UP%,MouseMoveByKey 
Hotkey,%DIRE_DOWN%,MouseMoveByKey
Hotkey,%DIRE_RIGHT%,MouseMoveByKey
Hotkey,%DIRE_LEFT%,MouseMoveByKey
Hotkey,%TO_LOCATION_MODE%,SwitchToLocationMode

if LEVEL1_KEY
	Hotkey,%LEVEL1_KEY%,MouseMoveByKey
if LEVEL2_KEY
	Hotkey,%LEVEL2_KEY%,MouseMoveByKey
if LEVEL3_KEY
	Hotkey,%LEVEL3_KEY%,MouseMoveByKey
if QUICK_MODE_KEY
	Hotkey,%QUICK_MODE_KEY%,MouseMoveByKey

iniread,TurnOff,%INI_PATH%,Start,TurnOff
Hotkey,%TurnOff%,TurnOffMouseKeyboardMode

       
; mouse module event
iniread,Event,%INI_PATH%,Event
Loop,parse,Event,`n,`r
{
	if (A_LoopField="")
		continue
	
	Fname :=RegExReplace(A_LoopField,"=.*?$")
	Fkey :=RegExReplace(A_LoopField,"^.*?=") 
	
	try
		Hotkey,%Fkey%,%Fname%
	catch
		MsgBox, Error: %A_LoopField%
	
	if (Fname == "ClickLeftMouse")
		CLICK_KEY := Fkey

	
}




#IfWinActive CoordGrid

	
	/*	
	CapsLock::
		WinSet, Transparent, 200, CoordGrid
		KeyWait, CapsLock  ; Wait for user to physically release it.
		WinSet, Transparent, 140, CoordGrid
		return
	*/
	
	esc::
		Gui, Hide
		gosub, TurnOnMouseKeyboardMode
	return 

	left::
		WinGetPos ,  currentposX, currentposY,,, CoordGrid
		winmove, CoordGrid,, % currentposX-16
	return 

	right:: 
		WinGetPos ,  currentposX, currentposY,,, CoordGrid
		winmove, CoordGrid,, % currentposX+16
	return

	Up:: 
		WinGetPos ,  currentposX, currentposY,,, CoordGrid
		winmove, CoordGrid,, , % currentposY-16
	return

	Down:: 
		WinGetPos ,  currentposX, currentposY,,, CoordGrid
		winmove, CoordGrid,, , % currentposY+16
	return

	~a:: gosub, RunKey
	~b:: gosub, RunKey
	~c:: gosub, RunKey
	~d:: gosub, RunKey
	~e:: gosub, RunKey
	~f:: gosub, RunKey
	~g:: gosub, RunKey
	~h:: gosub, RunKey
	~i:: gosub, RunKey
	~j:: gosub, RunKey
	~k:: gosub, RunKey
	~l:: gosub, RunKey
	~m:: gosub, RunKey
	~n:: gosub, RunKey
	~o:: gosub, RunKey
	~p:: gosub, RunKey
	~q:: gosub, RunKey
	~r:: gosub, RunKey
	~s:: gosub, RunKey
	~t:: gosub, RunKey
	~u:: gosub, RunKey
	~v:: gosub, RunKey
	~w:: gosub, RunKey
	~x:: gosub, RunKey
	~y:: gosub, RunKey
	~z:: gosub, RunKey

	Runkey:
	      global winc_presses
	      winc_presses += 1
	      if winc_presses = 2  
	      {
			NavigateToCoord()
			winc_presses = 0
			
		        global QUICK_MODE 
			global DEFAULT_SPEED 
			QUICK_MODE := false
			DEFAULT_SPEED := LEVEL1
			goSub, TurnOnMouseKeyboardMode 
         	}
	Return	

	NavigateToCoord()
	{
		CoordMode, Mouse, Window
		global numberOfRows, numberOfCols, rowSpacing, colSpacing, customDPI

		XCoordInput := SubStr(A_ThisHotkey,2,1)
		YCoordInput := SubStr(A_PriorHotkey,2,1)
		XCoordToUse := ConvertInputCoord(XcoordInput, "X")
		YCoordToUse := ConvertInputCoord(YcoordInput, "Y")

		XCoord := (XCoordToUse+0.26) * colSpacing * customDPI
		YCoord := (YCoordToUse-0.60) * rowSpacing * customDPI


		MouseMove, %XCoord%, %YCoord%, 0
		Gui Hide
		;Click
		Return
	}

	ConvertInputCoord(coordInput, XorY)
	{
		global AscA
		coordAsc := Asc(coordInput)
		if (XorY = "X") {
			coordToUse := coordAsc - AscA
		}
		else {
			coordToUse := coordAsc - AscA + 1
		}
		coordToUse := floor(coordToUse) 
		Return coordToUse
	}
#IfWinActive


iniread,UseSpace,%INI_PATH%,Start,UseSpace+
iniread,UseCapslock,%INI_PATH%,Start,UseCapslock+

#If MOUSE_KEYBOARD_MODEL

#If



#If (UseSpace == "true")
	
	$Space:: 

	Gosub,SpaceModle       
	return  

#If
	
#If (UseCapslock == "true")
	*Capslock:: 
		MOUSE_KEYBOARD_MODEL := true
		
		CapsLockIn := true
		KeyWait, Capslock 
		MOUSE_KEYBOARD_MODEL := false
		CapsLockIn := false

		If( A_ThisHotkey =="*Capslock")
			SetCapsLockState, % (State:=!State) ? "On" : "Off" 

	Return 
#If

SpaceModle:
      
		MOUSE_KEYBOARD_MODEL := true   
		SpaceIn := true
		KeyWait, Space
		MOUSE_KEYBOARD_MODEL := false
		SpceIn := false
		If( A_ThisHotkey =="$Space")
			send,{Space}   
return 

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
			
			
			If !MOUSE_KEYBOARD_MODEL
			{
				break
			}
			
			; can't exit this Thread outside
			; thus, opinion inside
			if (UseCapslock and CapsLockIn and !GetKeyState("CapsLock", "P"))
			{
				break
			}
			
			if (UseSpace and SpaceIn and !GetKeyState("Space", "P"))
			{
				break
			}
			
			
			If (QUICK_MODE_KEY and GetKeyState(QUICK_MODE_KEY, "P")) or (CLICK_KEY and GetKeyState(CLICK_KEY, "P"))
				QUICK_MODE := true

			Else If (LEVEL1_KEY and GetKeyState(LEVEL1_KEY,"P") )
			{
				QUICK_MODE := false
				DEFAULT_SPEED := LEVEL1
			}
			
			Else If (LEVEL2_KEY and GetKeyState(LEVEL2_KEY,"P"))
			{
				QUICK_MODE := false
				DEFAULT_SPEED := LEVEL2
			}
			
			Else If (LEVEL3_KEY and GetKeyState(LEVEL3_KEY,"P"))
			{
				QUICK_MODE := false
				DEFAULT_SPEED := LEVEL3
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
					speed := speed + QUICK_MODE_UP_SPEED
				else
					speed := speed + NORMAL_MODEL_UP_SPEED
			}
			Else ; or switch to default
			{
				speed := DEFAULT_SPEED
			}
			
			If (cur_k == DIRE_RIGHT)
			{
			   x_speed := speed
			}

			else If (cur_k == DIRE_LEFT)
			{
			
			   x_speed := -speed
			}

			else If (cur_k == DIRE_DOWN)
			{

			   y_speed := speed
			}

			else If (cur_k == DIRE_UP)
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

Start:
	global STARTED
	STARTED := true
	if ( StartWithLocationMode == "true") {
	  Gui, Show
	} else {
	  goSub, TurnOnMouseKeyboardMode 
	}
return 

Stop:
	Gui, hide
        
	gosub, TurnOffMouseKeyboardMode
	
	global STARTED
	STARTED := false
return 

; start and stop
SwitchMouseKeyboardModel:
	global STARTED
        if STARTED
		gosub, Stop
	else
		gosub, Start
return 

TurnOnMouseKeyboardMode:
	global MOUSE_KEYBOARD_MODEL
	MOUSE_KEYBOARD_MODEL := true
	SetSystemCursor()
return


TurnOffMouseKeyboardMode:

	global MOUSE_KEYBOARD_MODEL
	If MOUSE_KEYBOARD_MODEL
	{
		MOUSE_KEYBOARD_MODEL := false
		RestoreSystemCursor()
	}
return 

Switch2Quick()
{
	global QUICK_MODE
	QUICK_MODE := true
}

SwitchToLocationMode:
	gosub, TurnOffMouseKeyboardMode
	Gui, Show
return

Menu_Ini(){
	global INI_PATH
	Run,%INI_PATH%
}
	
Menu_Reload(){
	Reload
}
	
	
Menu_Exit(){
	ExitApp
}

ExitApp__:
	ExitApp
return


#Include Functions.ahk
