hook global WinSetOption filetype=rust %{
    set-option window formatcmd 'rustfmt'

    # Format on save
    hook buffer BufWritePre .* %{format}

}

