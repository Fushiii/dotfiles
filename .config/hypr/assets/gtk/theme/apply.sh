#!/usr/bin/env bash

theme_assets_path="$HOME/.config/hypr/assets/gtk/theme"
theme_path="$HOME/.themes/base16"

check_link() {
	local file="$1"

	if [ -L "$theme_path/$file" ]; then
		link_target=$(readlink "$theme_path/$file")

		if [ "$link_target" != "$theme_assets_path/$file" ]; then
			unlink "$theme_path/$file"
			ln -s "$theme_assets_path/$file" "$theme_path/$file"
		fi
	else
		ln -s "$theme_assets_path/$file" "$theme_path/$file"
	fi
}

# Define a list of allowed values
allowed_values=("gtk2" "gtk3")

# Function to check if a value is allowed
is_allowed_value() {
    local value="$1"
    if [ "$value" == "all" ]; then
        return 0  # 'all' is allowed
    fi
    for allowed_value in "${allowed_values[@]}"; do
        if [ "$value" == "$allowed_value" ]; then
            return 0  # Value is allowed
        fi
    done
    return 1  # Value is not allowed
}

# Function to check if all values in the list are allowed
are_all_values_allowed() {
    local values=("$@")
    for value in "${values[@]}"; do
        if ! is_allowed_value "$value"; then
            return 1  # Not all values are allowed
        fi
    done
    return 0  # All values are allowed
}

# Define the main function
main() {
    local values=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
        check)
            shift
            values+=("$@")
            if [ ${#values[@]} -eq 0 ]; then
                # Apply all allowed values
                for value in "${allowed_values[@]}"; do
                    check_link "$value"
                done
                timeout 0.2 xsettingsd
                exit 1
            elif [ "${values[*]}" == "all" ]; then
                # Apply all allowed values
                for value in "${allowed_values[@]}"; do
                    check_link "$value"
                done
                timeout 0.2 xsettingsd
                exit 1
            elif are_all_values_allowed "${values[@]}"; then
                # Apply provided values
                for value in "${values[@]}"; do
                    check_link "$value"
                done
                timeout 0.2 xsettingsd
                exit 1
            else
                echo "Invalid operation."
                exit 1
            fi
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
        esac
        shift
    done
}

# Call the main function with provided arguments
main "$@"
