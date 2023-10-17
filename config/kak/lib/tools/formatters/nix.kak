hook global WinSetOption filetype=nix %{
    set-option window formatcmd 'nixpkgs-fmt'

    # Format on save
    hook buffer BufWritePre .* %{format}

}

