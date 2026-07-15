-- Edit in Neovim — Launch Services droplet.
--
-- Receives files opened via Finder / "Open With" / other graphical apps and
-- hands each one to the shell editor entry point, which routes the edit into a
-- ghostty + zellij tab. Detached with nohup so this applet returns immediately
-- instead of lingering while neovim is open.

on open theFiles
    set editorScript to (POSIX path of (path to home folder)) & ".config/scripts/macos/editor.sh"
    repeat with f in theFiles
        set p to POSIX path of f
        do shell script "nohup " & quoted form of editorScript & " " & quoted form of p & " >/dev/null 2>&1 &"
    end repeat
end open
