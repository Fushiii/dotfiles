# Relative lines for the editor.
hook global WinCreate ^[^*]+$ %{ add-highlighter window/ number-lines -relative }

# Raibow pairing
# This is the plugin needed for that.
bundle kak-rainbower "https://github.com/fushiii/kak-rainbower"

# Enable the raindow pairing in all buffers
rainbow-enable-window
