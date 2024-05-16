bundle parinfer-rust "eraserhd/parinfer-rust" %{
   hook global WinSetOption filetype=(clojure|lisp|scheme|racket|yuck) %{
        parinfer-enable-window -smart
    }
}
