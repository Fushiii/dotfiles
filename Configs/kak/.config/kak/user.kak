evaluate-commands %sh{
  config="$HOME/.config/kak/lib"
  find "$config" -type f -name '*.kak' | while read -r file; do
    printf 'source "%s"\n' "$file"
  done
}

