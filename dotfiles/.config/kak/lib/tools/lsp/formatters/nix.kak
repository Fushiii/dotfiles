hook global WinSetOption filetype=nix %{
     hook window BufWritePre .* lsp-formatting-sync
}

