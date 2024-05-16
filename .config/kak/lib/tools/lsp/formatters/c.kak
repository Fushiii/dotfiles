hook global WinSetOption filetype=(c) %{
     hook window BufWritePre .* lsp-formatting-sync
}
