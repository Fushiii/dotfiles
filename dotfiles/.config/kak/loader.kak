# Load the system defaults.
# Without this, i haven't been able to make syntax highlight work.
nop %sh{
    mkdir -p "$kak_config/autoload"
    if [ ! -e "$kak_config/autoload/system-library" ]; then
	ln -s "$kak_runtime/rc" "$kak_config/autoload/system-library"
    fi

}
