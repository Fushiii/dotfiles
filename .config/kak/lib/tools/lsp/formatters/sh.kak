hook global WinSetOption filetype=(sh) %{
    set-option global formatcmd "shfmt"

    hook window BufWritePre .*  %{
    	format
    }

}
