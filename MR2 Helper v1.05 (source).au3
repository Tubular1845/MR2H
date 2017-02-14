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
#include <NomadMemory.au3>
#Include <AutoItConstants.au3>


Global $lifespanindex, $fatigue, $stress, $recommendedaction, $nfatigue, $sb1, $writefile= @ScriptDir & "\statlog.txt"
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
Global $halffatigue, $fulllifestage, $lifestage , $lifespan, $fulllifespan
Global $toomuchstress
Global $nostressfatigue
Global $lifespanindexwithmintleaf
Global $lifespanindexwithnutsoil
Global $fatiguewithmango
Global $fatiguewithnutsoil
Global $stresswithmintleaf
Global $hWnd


#cs run this to check if you have administrative rights.
If Not IsAdmin() Then
    Msgbox(4096, "Administrative Rights", "You do not have administrative rights.")
EndIf
#ce

$Form1 = GUICreate("Monster Rancher 2 Helper", 364, 388, 208, 140)
$stressbox = GUICtrlCreateInput("", 296, 240, 41, 21)
$fatiguebox = GUICtrlCreateInput("", 296, 272, 41, 21)
$Label1 = GUICtrlCreateLabel("Stress", 256, 240, 33, 17)
$Label2 = GUICtrlCreateLabel("Fatigue", 248, 272, 39, 17)
$Label3 = GUICtrlCreateLabel("Lifespan Index:", 224, 304, 76, 17)
$lifespanindexlabel = GUICtrlCreateLabel("", 304, 304, 36, 17)
$actio = GUICtrlCreateLabel("Training:", 48, 80, 39, 17)
$actionlabel = GUICtrlCreateInput("", 104, 80, 53, 17)
$lifevalue = GUICtrlCreateInput("", 296, 16, 41, 21)
$powervalue = GUICtrlCreateInput("", 296, 48, 41, 21)
$intvalue = GUICtrlCreateInput("", 296, 80, 41, 21)
$skillvalue = GUICtrlCreateInput("", 296, 112, 41, 21)
$speedvalue = GUICtrlCreateInput("", 296, 144, 41, 21)
$defensevalue = GUICtrlCreateInput("", 296, 176, 41, 21)
$Label4 = GUICtrlCreateLabel("Life", 272, 16, 21, 17)
$Label5 = GUICtrlCreateLabel("Power", 256, 48, 34, 17)
$Label6 = GUICtrlCreateLabel("Intelligence", 232, 80, 58, 17)
$Label7 = GUICtrlCreateLabel("Skill", 264, 112, 23, 17)
$Label8 = GUICtrlCreateLabel("Speed", 256, 144, 35, 17)
$Label9 = GUICtrlCreateLabel("Defense", 248, 176, 44, 17)
$Label10 = GUICtrlCreateLabel("Total Stats", 240, 208, 52, 17)
$Label13 = GUICtrlCreateLabel("Recommended training and items", 17, 16, 161, 17)
$totalstats = GUICtrlCreateInput("", 296, 208, 41, 21)
$logbutton = GUICtrlCreateButton("Log Stats", 224, 336, 107, 33)
$Label11 = GUICtrlCreateLabel("Item:", 59, 54, 29, 17)
$recommendeditem = GUICtrlCreateInput("", 104, 54, 69, 17)
$Always_OnTop = GUICtrlCreateCheckbox("Always On Top", 8, 360, 97, 17)
$statgroup = GUICtrlCreateGroup("", 216, 0, 137, 377)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$training_group = GUICtrlCreateGroup("", 8, 0, 193, 113)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label12 = GUICtrlCreateLabel("Life Stage", 56, 136, 52, 17)
$Label14 = GUICtrlCreateLabel("Weeks left to live", 24, 160, 86, 17)
$lifestagebox = GUICtrlCreateInput("", 112, 128, 49, 21)
$lifespanremainingbox = GUICtrlCreateInput("", 112, 160, 49, 21)
$lifestagegroup = GUICtrlCreateGroup("", 8, 112, 193, 81)
GUICtrlCreateGroup("", -99, -99, 1, 1)
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

Life_Stage()

Lifespan_Remaining()

recommendeditems2()

If GUICtrlRead($Always_OnTop) = 1 Then
   AlwaysOnTop()
Else
   NotOnTop()
EndIf

;reduce CPU usage
Sleep(100)

WEnd

Func Lifespan_Remaining()
   GUICtrlSetData($lifespanremainingbox, $lifespan)
EndFunc

Func Life_Stage()
;Read the value for life stage and then display a more usable value
If $lifestage = 0 Then
   GUICtrlSetData($lifestagebox, "Infancy")
   EndIf
If $lifestage = 1 Then
   GUICtrlSetData($lifestagebox, "Childhood")
   EndIf
If $lifestage = 2 Then
   GUICtrlSetData($lifestagebox, "Adolescence")
   EndIf
If $lifestage = 3 Then
   GUICtrlSetData($lifestagebox, "Adolescence 2")
   EndIf
If $lifestage = 4 Then
   GUICtrlSetData($lifestagebox, "Prime")
   EndIf
If $lifestage = 5 Then
   GUICtrlSetData($lifestagebox, "Late Prime")
   EndIf
If $lifestage = 6 Then
   GUICtrlSetData($lifestagebox, "Elder")
   EndIf
If $lifestage = 7 Then
   GUICtrlSetData($lifestagebox, "Elder 2")
   EndIf
If $lifestage = 8 Then
   GUICtrlSetData($lifestagebox, "Old Age")
   EndIf
If $lifestage = 9 Then
   GUICtrlSetData($lifestagebox, "Twilight Years")
   EndIf
EndFunc

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

Func AlwaysOnTop()
    ; Retrieve the handle of MR2H.
    $hWnd = WinGetHandle("Monster Rancher 2 Helper")

    ; Set the active window as being ontop using the handle returned by WinGetHandle.
    WinSetOnTop($hWnd, "", $WINDOWS_ONTOP)

 EndFunc

 Func NotOnTop()
   ; Remove the "topmost" state from the active window.
   WinSetOnTop($hWnd, "", $WINDOWS_NOONTOP)
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
$fulllifestage = $pointervalue + $lifestageoffset
$fulllifespan = $pointervalue + $lifespanoffset
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
$lifestage = _MemoryRead($fulllifestage, $DllInformation, 'byte')
$lifespan = _MemoryRead($fulllifespan, $DllInformation, 'short;int')

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
