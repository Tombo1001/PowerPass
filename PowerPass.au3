
#include <Clipboard.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global Const $CHR_AZ_LOW        = StringLower("abcdefghijklmnopqrstuvwxyz")
Global Const $CHR_AZ_UP        = StringUpper("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
Global Const $CHR_NUMBERS    = "0123456789"

Global $sUseCharacters = $CHR_AZ_LOW & $CHR_AZ_UP & $CHR_NUMBERS

$hWnd = GUICreate("PowerPass - Password Generator", 460, 175)
GUICtrlCreateGroup("Options", 10, 10, 280, 75)
GUICtrlCreateLabel("Password length:", 20, 30)
$hPasswordLength = GUICtrlCreateInput(8, 130, 27, 40)
$hUpDown = GUICtrlCreateUpDown($hPasswordLength)
GUICtrlCreateLabel("Characters:", 20, 53)
$hCharacters = GUICtrlCreateCombo("a-z, A-Z, 0-9", 130, 50, 150, 20, 0x0003)
;$hCurrentSequence = GUICtrlCreateLabel("Hover me to see your current sequence.", 10, 90, 280)
$hGenerate = GUICtrlCreateButton("Generate", 10, 110, 135, 25)
$hClearHistory = GUICtrlCreateButton("Clear history", 155, 110, 135, 25)
$hPassword = GUICtrlCreateInput("", 10, 145, 280, 20)
$hHistory = GUICtrlCreateEdit("", 300, 10, 150, 125, BitOR(0x0800, 0x0040, 0x00200000))
;$hCopyHistory = GUICtrlCreateButton("[Copy History]", 308, 142, 135, 25)

GUICtrlSetData($hCharacters, "A-Z, 0-9|a-z, 0-9|a-z, A-Z|A-Z|0-9|a-z", "a-z, A-Z, 0-9")
GUICtrlSetLimit($hUpDown, 99, 1)
;GUICtrlSetTip($hCurrentSequence, $sUseCharacters)
GUISetState()
While 1
    Switch GUIGetMsg()
        Case -3
            Exit
        Case $hCharacters
            $sRead = GUICtrlRead($hCharacters)
            If ($sRead == "a-z") Then
                $sUseCharacters = $CHR_AZ_LOW
            ElseIf ($sRead == "A-Z") Then
                $sUseCharacters = $CHR_AZ_UP
            ElseIf ($sRead == "0-9") Then
                $sUseCharacters = $CHR_NUMBERS
            ElseIf ($sRead == "a-z, A-Z") Then
                $sUseCharacters = $CHR_AZ_LOW & $CHR_AZ_UP
            ElseIf ($sRead == "a-z, 0-9") Then
                $sUseCharacters = $CHR_AZ_LOW & $CHR_NUMBERS
            ElseIf ($sRead == "A-Z, 0-9") Then
                $sUseCharacters = $CHR_AZ_UP & $CHR_NUMBERS
            ElseIf ($sRead == "a-z, A-Z, 0-9") Then
                $sUseCharacters = $CHR_AZ_LOW & $CHR_AZ_UP & $CHR_NUMBERS
            ;ElseIf ($sRead == "< User defined ... >") Then
                ;$sUseCharacters = InputBox("Password Generator.", "Enter a character sequence.", "abcABC123!@#", "", 200, 100)
            EndIf
            ;GUICtrlSetTip($hCurrentSequence, $sUseCharacters)

        Case $hGenerate
            $sPassword = _GeneratePassword(GUICtrlRead($hPasswordLength), $sUseCharacters)
			_ClipBoard_SetData($sPassword) ;copies newest password to clipboard
            GUICtrlSetData($hPassword, $sPassword)
            GUICtrlSetData($hHistory, $sPassword & @CRLF, "|")
		 ;Case $hCopyHistory
			;_ClipBoard_SetData($hHistory) ;copies history to clipboard !!!!!!!!!!!!!!!

        Case $hClearHistory
            GUICtrlSetData($hHistory, "")
    EndSwitch
WEnd

Func _GeneratePassword($iLength, $sSequence)
    Local $sResult
    Local $aSplit = StringSplit($sSequence, "", 2)

    For $i = 1 To $iLength
        $sResult &= $aSplit[Random(0, UBound($aSplit) - 1, 1)]
    Next

    Return $sResult
EndFunc
