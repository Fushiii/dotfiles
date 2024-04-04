bundle kak-rainbower "https://github.com/diegofariasm/kak-rainbower" %{
  hook global WinSetOption filetype=.* %{
      rainbow-enable-window
      set-option window rainbow_mode 0
  }
}
