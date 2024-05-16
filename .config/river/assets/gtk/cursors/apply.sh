#!/usr/bin/env bash

csv_file="$HOME/.config/river/configs/taste/cursors.csv"
river_cursors_color_path="$HOME/.config/river/assets/gtk/cursors/color"
river_cursors_theme_path="$HOME/.config/river/assets/gtk/cursors/theme"
cursors_assets_path="$HOME/.assets/cursors"
cursors_path="$HOME/.icons/base16-cursors"
cursors_cache_path="$HOME/.cache/gtk/cursors"

color_index=1 # For base05
color=$(awk -F',' 'NR==2 {print $'$((color_index + 1))'}' "$csv_file")
sanitized_color=$(echo "${color#"#"}" | tr -d '\r\n[:space:]')

# Check if the right cursors are in place.
# If not, will remove the link and put the right one in place.
check_link() {
	local theme="$1"
	cached_cursors_path="$cursors_cache_path/$theme/$sanitized_color"

	if [ -L "$cursors_path" ]; then
		link_target=$(readlink "$cursors_path")
		if [ "$link_target" != "$cached_cursors_path" ]; then
			unlink "$cursors_path"
			ln -s "$cached_cursors_path" "$cursors_path"
		fi
		# Check if the link points to a non-existent target directory
		if [ -n "$link_target" ] && [ ! -d "$link_target" ]; then
			check_cursors $theme
		fi
	elif [ ! -e "$cursors_path" ]; then
		ln -s "$cached_cursors_path" "$cursors_path"
	fi
}

# Check if the cursors are in cache / exists.
# If not, will recolor and cache them for usage.
check_cursors() {
	local theme="$1"
	mkdir -p "$cursors_cache_path/$theme"

	cached_cursors_path="$cursors_cache_path/$theme/$sanitized_color"
	echo "$cached_cursors_path"

	if [ ! -d "$cached_cursors_path" ]; then
		echo "cursors not found in cache, caching now..."

		case "$theme" in
		dark)
			cp -r "$cursors_assets_path/$theme" "$cached_cursors_path"

			;;
		light)
			cp -r "$cursors_assets_path/$theme" "$cached_cursors_path"

			;;
		*)
			cp -r "$cursors_assets_path/$theme" "$cached_cursors_path"
			;;
		esac
		echo "$cursors_assets_path/$theme $cached_cursors_path"

		echo "Recoloring cursors with color: ${color}"

		# Recolor cursors
		if ! recolor "$cached_cursors_path" --color "$color"; then
			echo "Failed to recolor cursors."
			exit 1 # or handle the error in some other way
		fi

		# Keep track of cursor color
		echo "$color" >"$cached_cursors_path/color"
		echo "$color" >"$river_cursors_color_path"
		echo "$theme" >"$river_cursors_theme_path"
	fi
}

recolor_cursors() {
	local theme="$1"

	# Check if the color file exists
	if [ -f "$river_cursors_color_path" ]; then
		river_cursors_color=$(cat "$river_cursors_color_path")
		sanitized_river_cursors_color=$(echo "${color#"#"}" | tr -d '\r\n[:space:]')
		if [ "$river_cursors_color" != "$color" ]; then
			echo "Replacing the cursors as colors do not coincide: $river_cursors_color $color"
			check_cursors $theme
		fi
	else
		check_cursors $theme
	fi

	check_link $theme
}

main() {
	local theme="dark"

	while [[ $# -gt 0 ]]; do
		case "$1" in
		--theme)
			shift
			theme="$1"
			;;
		check)
			shift
			previous_theme=$(cat "$river_cursors_theme_path")
			check_link $previous_theme
			exit 1
			;;
		*)
			echo "Unknown argument: $1"
			exit 1
			;;
		esac
		shift
	done

	if [ "$RECOLOR_ALL" = "true" ]; then
		case "$theme" in
		dark)
			recolor_cursors dark
			;;
		light)
			recolor_cursors light
			;;
		*)
			recolor_cursors dark
			;;
		esac
	fi

}

main "$@"
