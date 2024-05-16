bundle-customload kak-tree-sitter 'git clone -b kak-tree-sitter-v0.4.4 https://github.com/phaazon/kak-tree-sitter.git' %{
	eval %sh{ kak-tree-sitter -dsk --session $kak_session }
}

