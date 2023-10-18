hook global WinSetOption filetype=rust %{
     hook window BufWritePre .* lsp-formatting-sync
}

