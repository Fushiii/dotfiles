bundle kakboard "https://github.com/lePerdu/kakboard" %{
    hook global WinCreate .* %{ 
	kakboard-enable
     }
}
