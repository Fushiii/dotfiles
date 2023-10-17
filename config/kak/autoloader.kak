# Load the system defaults.
# Without this, i haven't been able to make syntax highlight work.
nop %sh{
    mkdir -p "$kak_config/autoload"

    if [ ! -e "$kak_config/autoload/standard-library" ]; then
	ln -s "$kak_runtime/rc" "$kak_config/autoload/standard-library"
    fi

}

# Load the user configuration.
# Note: with this i don't need to make a barrel file.
nop %sh{
    mkdir -p "$kak_config/autoload"
    if [ ! -e "$kak_config/autoload/user-library" ]; then
	    ln -s "$kak_config/lib" "$kak_config/autoload/user-library"
    fi
}

