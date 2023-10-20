# Load the config for the user shell.
# Note this recurses and loads everything
config="$HOME/.config/zsh/lib"

find "$config" -type f -name '*.zsh' | while read -r file; do
  source "$file"
done

