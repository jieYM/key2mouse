
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
Hotkey,%TurnOn%,SwitchMouseKeyboardModel


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

Hotkey, If, MOUSE_KEYBOARD_MODEL
Hotkey,%DIRE_UP%,MouseMoveByKey 
Hotkey,%DIRE_DOWN%,MouseMoveByKey
Hotkey,%DIRE_RIGHT%,MouseMoveByKey
Hotkey,%DIRE_LEFT%,MouseMoveByKey

if LEVEL1_KEY
	Hotkey,%LEVEL1_KEY%,MouseMoveByKey
if LEVEL2_KEY
	Hotkey,%LEVEL2_KEY%,MouseMoveByKey
if LEVEL3_KEY
	Hotkey,%LEVEL3_KEY%,MouseMoveByKey
if QUICK_MODE_KEY
	Hotkey,%QUICK_MODE_KEY%,MouseMoveByKey

iniread,TurnOff,%INI_PATH%,Start,TurnOff
Hotkey,%TurnOff%,TurnOffMouseKeyboardModel

       
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


SwitchMouseKeyboardModel:


	global MOUSE_KEYBOARD_MODEL
	MOUSE_KEYBOARD_MODEL := !MOUSE_KEYBOARD_MODEL
	
	If MOUSE_KEYBOARD_MODEL
		SetSystemCursor()
	Else	
		RestoreSystemCursor()
return 


TurnOffMouseKeyboardModel:

	global MOUSE_KEYBOARD_MODEL
	If MOUSE_KEYBOARD_MODEL
	{
		RestoreSystemCursor()
		MOUSE_KEYBOARD_MODEL := false
	}
return 

Switch2Quick()
{
	global QUICK_MODE
	QUICK_MODE := true
}


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