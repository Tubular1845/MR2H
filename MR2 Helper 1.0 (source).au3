#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPIFiles.au3>
#include <file.au3>
#include <WinAPI.au3>
#Include <Array.au3>
#Include <Security.au3>
#include <Memory.au3>
#include <NomadMemory.au3>



Global $lifespanindex, $fatigue, $stress, $recommendedaction, $nfatigue, $sb1, $writefile="C:\Users\Tubular\Desktop\Coding\statlog.txt"
Global $hProcess, $pBaseAddress, $pBuffer, $iSize, $iRead
Global $pointer, $lifeoffset, $poweroffset, $intoffset, $skilloffset, $speedoffset, $defenseoffset, $stressoffset, $fatigueoffset, $lifespanoffset, $lifestageoffset
Global $ID
Global $stressaddress
Global $Handle
Global $stressaddressread
Global $stressvalue2, $fatiguevalue2, $lifevalue2, $powervalue2, $intvalue2, $skillvalue2, $speedvalue2, $defensevalue2
Global $fullstress, $fullfatigue, $fulllife, $fullpower, $fullint, $fullskill, $fullspeed, $fulldefense
Global $pointer1, $pointer2, $pointervalue
Global $stressvalue, $fatiguevalue
Global $halffatigue
Global $toomuchstress
Global $nostressfatigue
Global $lifespanindexwithmintleaf
Global $lifespanindexwithnutsoil
Global $fatiguewithmango
Global $fatiguewithnutsoil
Global $stresswithmintleaf



#cs run this to check if you have administrative rights.
If Not IsAdmin() Then
    Msgbox(4096, "Administrative Rights", "You do not have administrative rights.")
EndIf
#ce


$Form1 = GUICreate("Monster Rancher 2 Helper", 466, 320, 192, 124)
$stressbox = GUICtrlCreateInput("", 32, 56, 129, 21)
$fatiguebox = GUICtrlCreateInput("", 32, 112, 129, 21)
$Label1 = GUICtrlCreateLabel("Stress", 40, 32, 33, 17)
$Label2 = GUICtrlCreateLabel("Fatigue", 40, 88, 39, 17)
$Label3 = GUICtrlCreateLabel("Lifespan Index:", 40, 144, 76, 17)
$lifespanindexlabel = GUICtrlCreateLabel($lifespanindex, 120, 144, 20, 17)
$actio = GUICtrlCreateLabel("Training:", 80, 256, 111, 17)
$actionlabel = GUICtrlCreateLabel("", 152, 256, 101, 17)
$lifevalue = GUICtrlCreateInput("", 320, 32, 105, 21)
$powervalue = GUICtrlCreateInput("", 320, 64, 105, 21)
$intvalue = GUICtrlCreateInput("", 320, 96, 105, 21)
$skillvalue = GUICtrlCreateInput("", 320, 128, 105, 21)
$speedvalue = GUICtrlCreateInput("", 320, 160, 105, 21)
$defensevalue = GUICtrlCreateInput("", 320, 192, 105, 21)
$Label4 = GUICtrlCreateLabel("Life", 288, 32, 21, 17)
$Label5 = GUICtrlCreateLabel("Power", 280, 64, 34, 17)
$Label6 = GUICtrlCreateLabel("Intelligence", 256, 96, 58, 17)
$Label7 = GUICtrlCreateLabel("Skill", 288, 128, 23, 17)
$Label8 = GUICtrlCreateLabel("Speed", 280, 160, 35, 17)
$Label9 = GUICtrlCreateLabel("Defense", 272, 192, 44, 17)
$Label10 = GUICtrlCreateLabel("Current stat total:", 280, 232, 84, 17)
$Label13 = GUICtrlCreateLabel("Recommended training and items", 65, 200, 161, 17)
$totalstats = GUICtrlCreateInput("", 368, 232, 57, 21)
$logbutton = GUICtrlCreateButton("Log Stats", 304, 272, 107, 33)
$Label11 = GUICtrlCreateLabel("Items:", 91, 230, 101, 17)
$recommendeditem = GUICtrlCreateLabel("x", 152, 230, 101, 17)
GUISetState(@SW_SHOW)
$lifespanindexwithmintleaf = GUICtrlRead($fatiguebox) + ($stresswithmintleaf * 2)
$lifespanindexwithnutsoil = $fatiguewithnutsoil + (GUICtrlRead($stressbox) * 2)
$lifespanindexwithmango = $fatiguewithmango + (GUICtrlRead($stressbox) * 2)
$nostressfatigue = GUICtrlRead($stressbox) + GUICtrlRead($fatiguebox)
$fatiguewithmango = GUICtrlRead($fatiguebox) - 10
$fatiguewithnutsoil = GUICtrlRead($fatiguebox) - 26
$stresswithmintleaf = GUICtrlRead($stressbox) / 2

While 1

FindProcess()

PullPointer_Values()

Offsets()

Error_Msgs()

Set_InfoBoxes()

Drill_Recommendation()

recommendeditems2()

Click_Func()

LogButton()

Total_Stats()

item_calc()

Round_Up()

recommendeditems2()
;lower CPU load
Sleep(100)

WEnd

Func Set_InfoBoxes()
;set the values for the various stats
GUICtrlSetData($stressbox, $stressvalue)
GUICtrlSetData($fatiguebox, $fatiguevalue)
GUICtrlSetData($lifevalue, $lifevalue2)
GUICtrlSetData($powervalue, $powervalue2)
GUICtrlSetData($intvalue, $intvalue2)
GUICtrlSetData($skillvalue, $skillvalue2)
GUICtrlSetData($speedvalue, $speedvalue2)
GUICtrlSetData($defensevalue, $defensevalue2)
GUICtrlSetData($totalstats, ($defensevalue2 + $lifevalue2 + $powervalue2 + $intvalue2 + $skillvalue2 + $speedvalue2))

EndFunc

Func FindProcess()
;find the pSX process and close if not found
   Opt("WinTitleMatchMode", 4)
Global $ProcessID = WinGetProcess("pSX v1.13","")

If $ProcessID = -1 Then
    MsgBox(4096, "ERROR", "Failed to detect process.")
    Exit
EndIf

    Global $DllInformation = _MemoryOpen($ProcessID)

If @Error Then
        MsgBox(4096, "ERROR", "Failed to open memory. 2")
        Exit
	 EndIf

If @Error Then
        MsgBox(4096, "ERROR", "Failed to read memory. 1")
        Exit
	 EndIf

EndFunc

Func Total_Stats()
;Total the stats and update the input box for total value
GUICtrlSetData($totalstats, GUICtrlRead($powervalue) + GUICtrlRead($intvalue) + GUICtrlRead($skillvalue) + GUICtrlRead($speedvalue) + GUICtrlRead($lifevalue) + GUICtrlRead($defensevalue))

EndFunc

Func LogButton()
$nMsg = GUIGetMsg()
Switch $nMsg
   Case $GUI_EVENT_CLOSE
		 Exit
   ;Log stats
   Case $logbutton
	 Write_Func()
  EndSwitch
EndFunc


Func Drill_Recommendation()

;Read the lifespan index and determine the best course of action

Switch GUICtrlRead($lifespanindexlabel)
   Case 0 To 31
		 GUICtrlSetData($actionlabel,"HD")
   Case 32 To 50
		 GUICtrlSetData($actionlabel,"LD")
   Case 51 To 100
		 GUICtrlSetData($actionlabel,"Rest")
EndSwitch

EndFunc

Func Error_Msgs()
;error messages
If @Error Then
        MsgBox(4096, "ERROR", "Failed to open memory. 2")
        Exit
	 EndIf

If @Error Then
        MsgBox(4096, "ERROR", "Failed to read memory. 1")
        Exit
	 EndIf

EndFunc

Func Offsets()
;pointer and offsets
$pointer1 = 0x0571A5C
$lifeoffset = 0x97A20
$poweroffset = 0x97A22
$intoffset = 0x97A2A
$skilloffset = 0x97A26
$speedoffset = 0x97A28
$defenseoffset = 0x97A24
$fatigueoffset = 0x97A37
$lifespanoffset = 0x97A30
$lifestageoffset = 0x97B93
$fullstress = $pointervalue + 0x97A3B
$fullfatigue = $pointervalue + 0x97A37
$fulllife = $pointervalue + $lifeoffset
$fullpower = $pointervalue + $poweroffset
$fullint = $pointervalue + $intoffset
$fullskill = $pointervalue + $skilloffset
$fullspeed = $pointervalue + $speedoffset
$fulldefense = $pointervalue + $defenseoffset
$lifespanindex = ($fatiguevalue + ($stressvalue*2))

EndFunc

Func PullPointer_Values()
;apply pointer values to variables
$pointervalue = _MemoryRead($pointer1, $DllInformation, 'int')
$stressvalue = _MemoryRead ($fullstress, $DllInformation, 'byte')
$fatiguevalue = _MemoryRead($fullfatigue, $DllInformation, 'byte')
$lifevalue2 = _MemoryRead($fulllife, $DllInformation, 'byte')
$powervalue2 = _MemoryRead($fullpower, $DllInformation, 'byte')
$intvalue2 = _MemoryRead($fullint, $DllInformation, 'byte')
$skillvalue2 = _MemoryRead($fullskill, $DllInformation, 'byte')
$speedvalue2 = _MemoryRead($fullspeed, $DllInformation, 'byte')
$defensevalue2 = _MemoryRead($fulldefense, $DllInformation, 'byte')

EndFunc

Func LifespanIndex_WithItems()
;lifespan index after various actions
$lifespanindexwithmintleaf = GUICtrlRead($fatiguebox) + ($stresswithmintleaf * 2)
$lifespanindexwithnutsoil = $fatiguewithnutsoil + (GUICtrlRead($stressbox) * 2)
$lifespanindexwithmango = $fatiguewithmango + (GUICtrlRead($stressbox) * 2)
$nostressfatigue = GUICtrlRead($stressbox) + GUICtrlRead($fatiguebox)
$fatiguewithmango = GUICtrlRead($fatiguebox) - 10
$fatiguewithnutsoil = GUICtrlRead($fatiguebox) - 26
$stresswithmintleaf = GUICtrlRead($stressbox) / 2

EndFunc

Func recommendeditems2()
;what should you feed this thing?
If GUICtrlRead($fatiguebox) = GUICtrlRead($stressbox) And GUICtrlRead($fatiguebox) > 0 And GUICtrlRead($stressbox) > 0 And GUICtrlRead($stressbox) < 26 Then
   GuiCtrlSetData($recommendeditem, "Nuts Oil")
EndIf

If GUICtrlRead($fatiguebox) = 0 And GUICtrlRead($stressbox) = 0 Then
   GuiCtrlSetData($recommendeditem, "Free week!")
EndIf

If $lifespanindexwithnutsoil < $lifespanindexwithmintleaf And $lifespanindexwithnutsoil < $lifespanindexwithmango Then
   GuiCtrlSetData($recommendeditem, "Nuts Oil")
EndIf

If $lifespanindexwithmintleaf < $lifespanindexwithnutsoil And $lifespanindexwithmintleaf < $lifespanindexwithmango Then
   GuiCtrlSetData($recommendeditem, "Mint Leaf")
EndIf

If GUICtrlRead($fatiguebox) = GUICtrlRead($stressbox) And GUICtrlRead($fatiguebox) > 0 And GUICtrlRead($stressbox) > 0 And GUICtrlRead($stressbox) < 26 Then
   GuiCtrlSetData($recommendeditem, "Nuts Oil")
EndIf

If $lifespanindexwithmango = $lifespanindexwithnutsoil And $lifespanindexwithmango < $lifespanindexwithmintleaf Then
   GuiCtrlSetData($recommendeditem, "Mango")
EndIf

EndFunc

Func item_calc()
;i guess i did this twice, lol
$lifespanindexwithmintleaf = GUICtrlRead($fatiguebox) + ($stresswithmintleaf * 2)
$lifespanindexwithnutsoil = $fatiguewithnutsoil + (GUICtrlRead($stressbox) * 2)
$lifespanindexwithmango = $fatiguewithmango + (GUICtrlRead($stressbox) * 2)
$nostressfatigue = GUICtrlRead($stressbox) + GUICtrlRead($fatiguebox)
$fatiguewithmango = GUICtrlRead($fatiguebox) - 10
$fatiguewithnutsoil = GUICtrlRead($fatiguebox) - 26
$stresswithmintleaf = GUICtrlRead($stressbox) / 2

EndFunc


Func Round_Up()
;prevents fatigue from showing as a negative value, rounds up to 0
If $fatiguewithmango < 0 Then
$fatiguewithmango = 0
EndIf
If $fatiguewithnutsoil < 0 Then
$fatiguewithnutsoil = 0
EndIf

EndFunc


Func Click_Func()
;Update the lifespan index label with the information in the input boxes
	  GUICtrlSetData($lifespanindexlabel, (GUICtrlRead($fatiguebox) + (GUICtrlRead($stressbox) * 2)))
	  $lifespanindex = GUICtrlRead($lifespanindexlabel)
EndFunc


Func Write_Func()
;function for saving stats, this will be used more later for statistics
$hfile=FileOpen($writefile,$FO_APPEND)
    FileWrite($hfile,"Life " & GUICtrlRead($lifevalue) & @CRLF)
	FileWrite($hfile,"Power " & GUICtrlRead($powervalue) & @CRLF)
	FileWrite($hfile,"Intelligence " & GUICtrlRead($intvalue) & @CRLF)
	FileWrite($hfile,"Skill " & GUICtrlRead($skillvalue) & @CRLF)
	FileWrite($hfile,"Speed " & GUICtrlRead($speedvalue) & @CRLF)
	FileWrite($hfile,"Defense " & GUICtrlRead($defensevalue) & @CRLF)
	FileWrite($hfile,"Stress " & $stressvalue & @CRLF)
	FileWrite($hfile,"Fatigue " & GUICtrlRead($fatiguebox) & @CRLF)
	FileWrite($hfile,"Lifespan Index " & GUICtrlRead($lifespanindexlabel) & @CRLF)
FileClose($hfile)
EndFunc
