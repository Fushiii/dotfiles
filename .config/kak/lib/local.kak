hook global BufCreate (.*/)?(\.kakrc\.local) %{
    set-option buffer filetype kak
}

try %{ source .kakrc.local }
