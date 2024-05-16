nop %sh{
    create_symlink() {
        source_path="$1"
        symlink_path="$2"

        mkdir -p "$(dirname "$symlink_path")"

        if [ -L "$symlink_path" ]; then
            target_path=$(readlink -f "$symlink_path")
            if [ ! -e "$target_path" ]; then
                ln -sf "$source_path" "$symlink_path"
            fi
        else
            ln -s "$source_path" "$symlink_path"
        fi
    }

    create_symlink $kak_config/configs/kak-lsp $XDG_CONFIG_HOME/kak-lsp
    create_symlink $kak_config/configs/kak-tree-sitter $XDG_CONFIG_HOME/kak-tree-sitter
    
    # The system library.
    # It takes care of a lot of this for us,
    # like setting the filetype and a bunch of other things.
    create_symlink "$kak_runtime/rc" "$kak_config/autoload/system-library"
}
