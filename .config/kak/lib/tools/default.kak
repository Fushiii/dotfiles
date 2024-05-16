bundle kak-lsp https://github.com/kak-lsp/kak-lsp %{
  hook global KakEnd .* lsp-exit

  lsp-inlay-diagnostics-enable global
  lsp-inlay-hints-enable global

  hook -once -always window WinSetOption filetype=.* %{
     remove-hooks window semantic-tokens
  }
}
