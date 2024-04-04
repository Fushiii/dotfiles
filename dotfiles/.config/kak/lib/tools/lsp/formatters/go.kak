hook global WinSetOption filetype=(go) %{
     hook window BufWritePre .* lsp-formatting-sync
}
