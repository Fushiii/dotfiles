# This is the plugin for the lsp protocol.
# Some defaults will also be set here, like format on save.
bundle kak-lsp https://github.com/kak-lsp/kak-lsp %{
  hook global KakEnd .* lsp-exit
} 
