# Source a local project kak config if it exists
# Make sure it is set as a kak filetype
hook global BufCreate (.*/)?(\.kakrc\.local) %{
    set-option buffer filetype kak
}

try %{ source .kakrc.local }
