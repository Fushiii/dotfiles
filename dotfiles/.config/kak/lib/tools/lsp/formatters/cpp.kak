hook global WinSetOption filetype=(cpp) %{
     hook window BufWritePre .* lsp-formatting-sync
}
