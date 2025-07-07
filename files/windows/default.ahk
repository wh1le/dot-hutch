#Requires AutoHotkey v2.0
#SingleInstance Force

; https://www.autohotkey.com/docs/v2/misc/Remap.htm

; ---- flood-control ----
A_MaxHotkeysPerInterval := 200   ; max hits inside the window
A_HotkeyInterval       := 1000   ; window in ms

; --- Key Remaps (Mac-style, **fixed**) ---
\::~

;––– CapsLock becomes Ctrl –––
CapsLock::Ctrl
SetCapsLockState "AlwaysOff"

; --- Language Switch ---
^Space::Send("#{Space}")  ; Ctrl + Space triggers Win + Space

; --- Disable Win+tab

#q:: {
    WinClose "A"
}

; !Space::Send "{Blind}{LWin down}{LWin up}"    ; fires the same press/release Win-key pulse Windows e

; --- App Launchers ---
#1:: ; Firefox
{
    if WinExist("ahk_exe firefox.exe")
        WinActivate("ahk_exe firefox.exe")
    else
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk")
}

#2:: ; WezTerm
{
    if WinExist("ahk_exe wezterm-gui.exe")
        WinActivate("ahk_exe wezterm-gui.exe")
    else
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\WezTerm.lnk")
}

#3:: ; Obsidian
{
    if WinExist("ahk_exe Obsidian.exe")
        WinActivate("ahk_exe Obsidian.exe")
    else
        Run("C:\Users\nmilo\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Obsidian.lnk")
}

#4:: ; TickTick
{
    if WinExist("ahk_exe TickTick.exe")
        WinActivate("ahk_exe TickTick.exe")
    else
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TickTick\TickTick.lnk")
}

#5:: ; Double Commander
{
    if WinExist("ahk_exe doublecmd.exe")
        WinActivate("ahk_exe doublecmd.exe")
    else
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Double Commander\Double Commander.lnk")
}

#8:: {
    Run "C:\Users\nmilo\Desktop\scrpts\monitor_toggle\elink_turn_off.bat"
}

#9:: {
    Run "C:\Users\nmilo\Desktop\scrpts\elink_toggle\elink_toggle.bat"
}
