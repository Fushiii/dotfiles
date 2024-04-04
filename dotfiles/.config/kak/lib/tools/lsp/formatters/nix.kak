hook global WinSetOption filetype=(nix) %{
    set-option global formatcmd "alejandra"
    hook window BufWritePre .*  %{
    	format
    }

}
