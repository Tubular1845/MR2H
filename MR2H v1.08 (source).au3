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
#Include <AutoItConstants.au3>
#include <NomadMemory.au3>
#include <ComboConstants.au3>

Global $lifevalue
Global $powervalue
Global $intvalue
Global $skillvalue
Global $speedvalue
Global $defensevalue
Global $lifespanindex, $fatigue, $stress, $recommendedaction, $nfatigue, $sb1, $writefile= @ScriptDir & "\statlog.txt"
Global $hProcess, $pBaseAddress, $pBuffer, $iSize, $iRead, $DllInformation
Global $pointer, $lifeoffset, $poweroffset, $intoffset, $skilloffset, $speedoffset, $defenseoffset, $stressoffset, $fatigueoffset, $lifespanoffset, $lifestageoffset
Global $ID, $fullmainbreed, $mainbreed, $fullsubbreed, $subbreed, $subbreedoffset, $mainbreedoffset
Global $stressaddress, $fearvalue, $fearaddr, $spoilvalue, $spoiladdr, $fearoffset, $spoiloffset
Global $Handle, $fullfear, $fullspoil
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
Global $hWnd, $totalstats



#cs run this to check if you have administrative rights.
If Not IsAdmin() Then
    Msgbox(4096, "Administrative Rights", "You do not have administrative rights.")
EndIf
#ce

;GUI
$Form1_1 = GUICreate("Monster Rancher 2 Helper", 365, 389, 198, 128)
$Always_OnTop = GUICtrlCreateCheckbox("Always On Top", 8, 360, 97, 17)
$statgroup = GUICtrlCreateGroup("", 216, 0, 137, 113)
$stressbox = GUICtrlCreateInput("", 264, 24, 41, 21)
$fatiguebox = GUICtrlCreateInput("", 264, 48, 41, 21)
$Label1 = GUICtrlCreateLabel("Stress", 229, 26, 33, 17)
$Label2 = GUICtrlCreateLabel("Fatigue", 224, 51, 39, 17)
$Label3 = GUICtrlCreateLabel("Lifespan Index:", 224, 80, 76, 17)
$lifespanindexlabel = GUICtrlCreateLabel("", 299, 80, 36, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$training_group = GUICtrlCreateGroup("", 8, 0, 193, 113)
$actio = GUICtrlCreateLabel("Training:", 59, 80, 39, 17)
$actionlabel = GUICtrlCreateInput("", 104, 80, 53, 21)
$Label13 = GUICtrlCreateLabel("Recommended training and items", 17, 16, 161, 17)
$Label11 = GUICtrlCreateLabel("Item:", 73, 57, 29, 17)
$recommendeditem = GUICtrlCreateInput("", 104, 54, 69, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$lifestagegroup = GUICtrlCreateGroup("", 8, 112, 193, 81)
$Label12 = GUICtrlCreateLabel("Life Stage", 56, 136, 52, 17)
$Label14 = GUICtrlCreateLabel("Weeks left to live", 24, 160, 86, 17)
$lifestagebox = GUICtrlCreateInput("", 112, 132, 77, 21)
$lifespanremainingbox = GUICtrlCreateInput("", 112, 157, 49, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$editgroup = GUICtrlCreateGroup("", 8, 192, 193, 137)
$Combo1 = GUICtrlCreateCombo("Pixie", 96, 232, 97, 25)
$Combo2 = GUICtrlCreateCombo("Pixie", 96, 264, 97, 25)
$editbreedlabel = GUICtrlCreateLabel("Edit breed/sub-breed", 56, 208, 104, 17)
$Label15 = GUICtrlCreateLabel("Main breed", 40, 235, 57, 17)
$Label16 = GUICtrlCreateLabel("Sub-breed", 40, 267, 53, 17)
$Button1 = GUICtrlCreateButton("Edit Monster permanently", 40, 296, 139, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$logbutton = GUICtrlCreateButton("Log Stats", 232, 344, 107, 33)
$Label4 = GUICtrlCreateLabel("Spoil", 232, 136, 27, 17)
$Label5 = GUICtrlCreateLabel("Fear", 232, 160, 25, 17)
$spoilbox = GUICtrlCreateInput("", 264, 133, 33, 21)
$fearbox = GUICtrlCreateInput("", 264, 157, 33, 21)
$Group1 = GUICtrlCreateGroup("", 216, 112, 137, 81)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)

$lifespanindexwithmintleaf = GUICtrlRead($fatiguebox) + ($stresswithmintleaf * 2)
$lifespanindexwithnutsoil = $fatiguewithnutsoil + (GUICtrlRead($stressbox) * 2)
$lifespanindexwithmango = $fatiguewithmango + (GUICtrlRead($stressbox) * 2)
$nostressfatigue = GUICtrlRead($stressbox) + GUICtrlRead($fatiguebox)
$fatiguewithmango = GUICtrlRead($fatiguebox) - 10
$fatiguewithnutsoil = GUICtrlRead($fatiguebox) - 26
$stresswithmintleaf = GUICtrlRead($stressbox) / 2

Edit_ComboBox()

While 1

FindProcess()

PullPointer_Values()

Offsets()

Error_Msgs()

Set_InfoBoxes()

AlwaysOnTop_()

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

;reduce CPU usage
Sleep(100)

WEnd

#cs
00 - Pixie
01 - Dragon
02 - Centaur
03 - Color Pandora
04 - Beaclon
05 - Henger
06 - Wracky
07 - Golem
08 - Zuum
09 - Durahan
0A - Arrow Head
0B - Tiger
0C - Hopper
0D - Hare
0E - Baku
0F - Gali
10 - Kato
11 - Zilla
12 - Bajarl
13 - Mew
14 - Phoenix
15 - Ghost
16 - Metalner
17 - Suezo
18 - Jill
19 - Mocchi
1A - Joker
1B - Gaboo
1C - Jell
1D - Undine
1E - Niton
1F - Mock
20 - Ducken
21 - Plant
22 - Monol
23 - Ape
24 - Worm
25 - Naga
26 - ??? (Enemy)
27 - ???
28 - ???
29 - ???
#ce

Func AlwaysOnTop_()
   If GUICtrlRead($Always_OnTop) = 1 Then
   AlwaysOnTop()
Else
   NotOnTop()
EndIf
EndFunc

Func Edit_MainBreed()
   ;Edit the main breed to the one selected in the Combo Box

 ;Pixie
 If GUICtrlRead($Combo1) = "Pixie" Then
	_MemoryWrite($fullmainbreed, $DllInformation,0x00, 'byte')
 EndIf
 ;Dragon
If GUICtrlRead($Combo1) = "Dragon" Then
   _MemoryWrite($fullmainbreed, $DllInformation,0x01, 'byte')
 EndIf
 ;Centaur
 If GUICtrlRead($Combo1) = "Centaur" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x02, 'byte')
 EndIf
 ;Color Pandora
 If GUICtrlRead($Combo1) = "Color Pandora" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x03, 'byte')
 EndIf
 ;Beaclon
 If GUICtrlRead($Combo1) = "Beaclon" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x04, 'byte')
 EndIf
 ;Henger
 If GUICtrlRead($Combo1) = "Henger" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x05, 'byte')
 EndIf
 ;Wracky
 If GUICtrlRead($Combo1) = "Wracky" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x06, 'byte')
 EndIf
 ;Golem
 If GUICtrlRead($Combo1) = "Golem" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x07, 'byte')
 EndIf
 ;Zuum
 If GUICtrlRead($Combo1) = "Zuum" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x08, 'byte')
 EndIf
 ;Durahan
 If GUICtrlRead($Combo1) = "Durahan" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x09, 'byte')
 EndIf
 ;Arrow Head
 If GUICtrlRead($Combo1) = "Arrow Head" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x0A, 'byte')
 EndIf
 ;Tiger
 If GUICtrlRead($Combo1) = "Tiger" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x0B, 'byte')
 EndIf
 ;Hopper
 If GUICtrlRead($Combo1) = "Hopper" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x0C, 'byte')
 EndIf
 ;Hare
 If GUICtrlRead($Combo1) = "Hare" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x0D, 'byte')
 EndIf
 ;Baku
 If GUICtrlRead($Combo1) = "Baku" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x0E, 'byte')
 EndIf
 ;Gali
 If GUICtrlRead($Combo1) = "Gali" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x0F, 'byte')
 EndIf
 ;Kato
 If GUICtrlRead($Combo1) = "Kato" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x10, 'byte')
 EndIf
 ;Zilla
 If GUICtrlRead($Combo1) = "Zilla" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x11, 'byte')
 EndIf
 ;Bajarl
 If GUICtrlRead($Combo1) = "Bajarl" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x12, 'byte')
 EndIf
 ;Mew
 If GUICtrlRead($Combo1) = "Mew" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x13, 'byte')
 EndIf
 ;Phoenix
 If GUICtrlRead($Combo1) = "Phoenix" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x14, 'byte')
 EndIf
 ;Ghost
 If GUICtrlRead($Combo1) = "Ghost" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x15, 'byte')
 EndIf
 ;Metalner
 If GUICtrlRead($Combo1) = "Metalner" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x16, 'byte')
 EndIf
 ;Suezo
 If GUICtrlRead($Combo1) = "Suezo" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x17, 'byte')
 EndIf
 ;Jill
 If GUICtrlRead($Combo1) = "Jill" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x18, 'byte')
 EndIf
 ;Mocchi
 If GUICtrlRead($Combo1) = "Mocchi" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x19, 'byte')
 EndIf
 ;Joker
 If GUICtrlRead($Combo1) = "Joker" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x1A, 'byte')
 EndIf
 ;Gaboo
 If GUICtrlRead($Combo1) = "Gaboo" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x1B, 'byte')
 EndIf
 ;Jell
 If GUICtrlRead($Combo1) = "Jell" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x1C, 'byte')
 EndIf
 ;Undine
 If GUICtrlRead($Combo1) = "Undine" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x1D, 'byte')
 EndIf
 ;Niton
 If GUICtrlRead($Combo1) = "Niton" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x1E, 'byte')
 EndIf
 ;Mock
 If GUICtrlRead($Combo1) = "Mock" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x1F, 'byte')
 EndIf
 ;Ducken
 If GUICtrlRead($Combo1) = "Ducken" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x20, 'byte')
 EndIf
 ;Plant
 If GUICtrlRead($Combo1) = "Plant" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x21, 'byte')
 EndIf
 ;Monol
 If GUICtrlRead($Combo1) = "Monol" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x22, 'byte')
 EndIf
 ;Ape
 If GUICtrlRead($Combo1) = "Ape" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x23, 'byte')
 EndIf
 ;Worm
 If GUICtrlRead($Combo1) = "Worm" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x24, 'byte')
 EndIf
 ;Naga
 If GUICtrlRead($Combo1) = "Naga" Then
 _MemoryWrite($fullmainbreed, $DllInformation,0x25, 'byte')
 EndIf
 EndFunc


 Func Edit_SubBreed()
	;Edit the sub breed to the one selected in the Combo Box
	 ;Pixie
 If GUICtrlRead($Combo2) = "Pixie" Then
	_MemoryWrite($fullsubbreed, $DllInformation,0x00, 'byte')
 EndIf
 ;Dragon
If GUICtrlRead($Combo2) = "Dragon" Then
   _MemoryWrite($fullsubbreed, $DllInformation,0x01, 'byte')
 EndIf
 ;Centaur
 If GUICtrlRead($Combo2) = "Centaur" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x02, 'byte')
 EndIf
 ;Color Pandora
 If GUICtrlRead($Combo2) = "Color Pandora" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x03, 'byte')
 EndIf
 ;Beaclon
 If GUICtrlRead($Combo2) = "Beaclon" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x04, 'byte')
 EndIf
 ;Henger
 If GUICtrlRead($Combo2) = "Henger" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x05, 'byte')
 EndIf
 ;Wracky
 If GUICtrlRead($Combo2) = "Wracky" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x06, 'byte')
 EndIf
 ;Golem
 If GUICtrlRead($Combo2) = "Golem" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x07, 'byte')
 EndIf
 ;Zuum
 If GUICtrlRead($Combo2) = "Zuum" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x08, 'byte')
 EndIf
 ;Durahan
 If GUICtrlRead($Combo2) = "Durahan" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x09, 'byte')
 EndIf
 ;Arrow Head
 If GUICtrlRead($Combo2) = "Arrow Head" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x0A, 'byte')
 EndIf
 ;Tiger
 If GUICtrlRead($Combo2) = "Tiger" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x0B, 'byte')
 EndIf
 ;Hopper
 If GUICtrlRead($Combo2) = "Hopper" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x0C, 'byte')
 EndIf
 ;Hare
 If GUICtrlRead($Combo2) = "Hare" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x0D, 'byte')
 EndIf
 ;Baku
 If GUICtrlRead($Combo2) = "Baku" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x0E, 'byte')
 EndIf
 ;Gali
 If GUICtrlRead($Combo2) = "Gali" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x0F, 'byte')
 EndIf
 ;Kato
 If GUICtrlRead($Combo2) = "Kato" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x10, 'byte')
 EndIf
 ;Zilla
 If GUICtrlRead($Combo2) = "Zilla" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x11, 'byte')
 EndIf
 ;Bajarl
 If GUICtrlRead($Combo2) = "Bajarl" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x12, 'byte')
 EndIf
 ;Mew
 If GUICtrlRead($Combo2) = "Mew" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x13, 'byte')
 EndIf
 ;Phoenix
 If GUICtrlRead($Combo2) = "Phoenix" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x14, 'byte')
 EndIf
 ;Ghost
 If GUICtrlRead($Combo2) = "Ghost" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x15, 'byte')
 EndIf
 ;Metalner
 If GUICtrlRead($Combo2) = "Metalner" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x16, 'byte')
 EndIf
 ;Suezo
 If GUICtrlRead($Combo2) = "Suezo" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x17, 'byte')
 EndIf
 ;Jill
 If GUICtrlRead($Combo2) = "Jill" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x18, 'byte')
 EndIf
 ;Mocchi
 If GUICtrlRead($Combo2) = "Mocchi" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x19, 'byte')
 EndIf
 ;Joker
 If GUICtrlRead($Combo2) = "Joker" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x1A, 'byte')
 EndIf
 ;Gaboo
 If GUICtrlRead($Combo2) = "Gaboo" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x1B, 'byte')
 EndIf
 ;Jell
 If GUICtrlRead($Combo2) = "Jell" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x1C, 'byte')
 EndIf
 ;Undine
 If GUICtrlRead($Combo2) = "Undine" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x1D, 'byte')
 EndIf
 ;Niton
 If GUICtrlRead($Combo2) = "Niton" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x1E, 'byte')
 EndIf
 ;Mock
 If GUICtrlRead($Combo2) = "Mock" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x1F, 'byte')
 EndIf
 ;Ducken
 If GUICtrlRead($Combo2) = "Ducken" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x20, 'byte')
 EndIf
 ;Plant
 If GUICtrlRead($Combo2) = "Plant" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x21, 'byte')
 EndIf
 ;Monol
 If GUICtrlRead($Combo2) = "Monol" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x22, 'byte')
 EndIf
 ;Ape
 If GUICtrlRead($Combo2) = "Ape" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x23, 'byte')
 EndIf
 ;Worm
 If GUICtrlRead($Combo2) = "Worm" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x24, 'byte')
 EndIf
 ;Naga
 If GUICtrlRead($Combo2) = "Naga" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x25, 'byte')
 EndIf
  If GUICtrlRead($Combo2) = "??? (Enemy)" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x26, 'byte')
 EndIf
  If GUICtrlRead($Combo2) = "??? 1" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x27, 'byte')
 EndIf
  If GUICtrlRead($Combo2) = "??? 2" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x28, 'byte')
 EndIf
  If GUICtrlRead($Combo2) = "??? 3" Then
 _MemoryWrite($fullsubbreed, $DllInformation,0x29, 'byte')
 EndIf
EndFunc

Func Edit_ComboBox()
       GUICtrlSetData($Combo1, "Dragon|Centaur|Color Pandora|Beaclon|Henger|Wracky|Golem|Zuum|Durahan|Arrow Head|Tiger|Hopper|Hare|Baku|Gali|Kato|Zilla|Mew|Phoenix|Ghost|Metalner|Suezo|Jill|Mocchi|Joker|Gaboo|Jell|Undine|Niton|Mock|Ducken|Plant|Monol|Ape|Worm|Naga", "")
       GUICtrlSetData($Combo2, "Dragon|Centaur|Color Pandora|Beaclon|Henger|Wracky|Golem|Zuum|Durahan|Arrow Head|Tiger|Hopper|Hare|Baku|Gali|Kato|Zilla|Mew|Phoenix|Ghost|Metalner|Suezo|Jill|Mocchi|Joker|Gaboo|Jell|Undine|Niton|Mock|Ducken|Plant|Monol|Ape|Worm|Naga|??? (Enemy)|??? 1|??? 2|??? 3", "")
EndFunc

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
GUICtrlSetData($spoilbox, $spoilvalue)
GUICtrlSetData($fearbox, $fearvalue)
GUICtrlSetData($stressbox, $stressvalue)
GUICtrlSetData($fatiguebox, $fatiguevalue)
$lifevalue = $lifevalue2
$powervalue = $powervalue2
$intvalue = $intvalue2
$skillvalue = $skillvalue2
$speedvalue = $speedvalue2
$defensevalue = $defensevalue2
$totalstats = $defensevalue2 + $lifevalue2 + $powervalue2 + $intvalue2 + $skillvalue2 + $speedvalue2


EndFunc

Func FindProcess()
;find the pSX process and close if not found
   Opt("WinTitleMatchMode", 4)
Global $ProcessID = WinGetProcess("pSX v1.13","")

If $ProcessID = -1 Then
    MsgBox(4096, "ERROR", "Failed to detect process.")
    Exit
EndIf

	  $DllInformation = _MemoryOpen($ProcessID)

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
GUICtrlSetData($totalstats, $powervalue + $intvalue + $skillvalue + $speedvalue + $lifevalue + $defensevalue)
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
   Case $Button1
     Edit_MainBreed()
	 Edit_SubBreed()
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
$mainbreedoffset = 0x97A18
$subbreedoffset = 0x97A1C
$spoiloffset = 0x97A3C
$fearoffset = 0x97A3D
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
$fullmainbreed = $pointervalue + $mainbreedoffset
$fullsubbreed = $pointervalue + $subbreedoffset
$fullspoil = $pointervalue + $spoiloffset
$fullfear = $pointervalue + $fearoffset
$lifespanindex = ($fatiguevalue + ($stressvalue*2))
EndFunc

Func PullPointer_Values()
;apply pointer values to variables
$pointervalue = _MemoryRead($pointer1, $DllInformation, 'int')
$stressvalue = _MemoryRead ($fullstress, $DllInformation, 'byte')
$fatiguevalue = _MemoryRead($fullfatigue, $DllInformation, 'byte')
$lifevalue2 = _MemoryRead($fulllife, $DllInformation, 'short;int')
$powervalue2 = _MemoryRead($fullpower, $DllInformation, 'short;int')
$intvalue2 = _MemoryRead($fullint, $DllInformation, 'short;int')
$skillvalue2 = _MemoryRead($fullskill, $DllInformation, 'short;int')
$speedvalue2 = _MemoryRead($fullspeed, $DllInformation, 'short;int')
$defensevalue2 = _MemoryRead($fulldefense, $DllInformation, 'short;int')
$lifestage = _MemoryRead($fulllifestage, $DllInformation, 'byte')
$lifespan = _MemoryRead($fulllifespan, $DllInformation, 'short;int')
$mainbreed = _MemoryRead($fullmainbreed, $DllInformation, 'byte')
$subbreed = _MemoryRead($fullsubbreed, $DllInformation, 'byte')
$spoilvalue = _MemoryRead($fullspoil, $DllInformation, 'byte')
$fearvalue = _MemoryRead($fullfear, $DllInformation, 'byte')
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
    FileWrite($hfile,"Life " & $lifevalue & @CRLF)
	FileWrite($hfile,"Power " & $powervalue & @CRLF)
	FileWrite($hfile,"Intelligence " & $intvalue & @CRLF)
	FileWrite($hfile,"Skill " & $skillvalue & @CRLF)
	FileWrite($hfile,"Speed " & $speedvalue & @CRLF)
	FileWrite($hfile,"Defense " & $defensevalue & @CRLF)
    FileWrite($hfile,"Total Stats " & $totalstats & @CRLF)
	FileWrite($hfile,"Stress " & $stressvalue & @CRLF)
	FileWrite($hfile,"Fatigue " & GUICtrlRead($fatiguebox) & @CRLF)
    FileWrite($hfile,"Spoil " & $spoilvalue & @CRLF)
	FileWrite($hfile,"Fear " & $fearvalue & @CRLF)
	FileWrite($hfile,"Lifespan Index " & GUICtrlRead($lifespanindexlabel) & @CRLF)
    FileWrite($hfile,"Lifespan Remaining " & GUICtrlRead($lifespan) & @CRLF & @CRLF)
FileClose($hfile)
EndFunc
