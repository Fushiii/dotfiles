#!/usr/bin/env bash

csv_file="$HOME/.config/river/configs/taste/icons.csv"
river_icons_color_path="$HOME/.config/river/assets/gtk/icons/color"
river_icons_theme_path="$HOME/.config/river/assets/gtk/icons/theme"
icons_assets_path="$HOME/.icons/assets/icons"
icons_path="$HOME/.icons/base16-icons"
icons_cache_path="$HOME/.cache/gtk/icons"

color_index=13
color=$(awk -F',' 'NR==2 {print $'$((color_index + 1))'}' "$csv_file")
echo $color
sanitized_color=$(echo "${color#"#"}" | tr -d '\r\n[:space:]')

# Check if the right icons are in place.
# If not, will remove the link and put the right one in place.
check_link() {
	local theme="$1"
	cached_icons_path="$icons_cache_path/$theme/$sanitized_color"

	if [ -L "$icons_path" ]; then
		link_target=$(readlink "$icons_path")
		if [ "$link_target" != "$cached_icons_path" ]; then
			unlink "$icons_path"
			ln -s "$cached_icons_path" "$icons_path"
		fi
		# Check if the link points to a non-existent target directory
		if [ -n "$link_target" ] && [ ! -d "$link_target" ]; then
			check_icons $theme
		fi
	elif [ ! -e "$icons_path" ]; then
		ln -s "$cached_icons_path" "$icons_path"
	fi
}

# Check if the icons are in cache / exists.
# If not, will recolor and cache them for usage.
check_icons() {
	local theme="$1"
	mkdir -p "$icons_cache_path/$theme"

	cached_icons_path="$icons_cache_path/$theme/$sanitized_color"
	echo "$cached_icons_path"

	if [ ! -d "$cached_icons_path" ]; then
		echo "icons not found in cache, caching now..."

		case "$theme" in
		dark)
			cp -r "$icons_assets_path/$theme" "$cached_icons_path"

			;;
		light)
			cp -r "$icons_assets_path/$theme" "$cached_icons_path"

			;;
		*)
			cp -r "$icons_assets_path/$theme" "$cached_icons_path"
			;;
		esac
		echo "$icons_assets_path/$theme $cached_icons_path"

		echo "Recoloring icons with color: ${color}"

		# Recolor icons
		if ! recolor "$cached_icons_path" --color "$color"; then
			echo "Failed to recolor icons."
			exit 1 # or handle the error in some other way
		fi

		# Keep track of cursor color
		echo "$color" >"$cached_icons_path/color"
		echo "$color" >"$river_icons_color_path"
		echo "$theme" >"$river_icons_theme_path"
	fi
}

recolor_icons() {
	local theme="$1"

	# Check if the color file exists
	if [ -f "$river_icons_color_path" ]; then
		river_icons_color=$(cat "$river_icons_color_path")
		sanitized_river_icons_color=$(echo "${color#"#"}" | tr -d '\r\n[:space:]')
		if [ "$river_icons_color" != "$color" ]; then
			echo "Replacing the icons as colors do not coincide: $river_icons_color $color"
			check_icons $theme
		fi
	else
		check_icons $theme
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
			previous_theme=$(cat "$river_icons_theme_path")
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

	if [ "$RECOLOR" = "true" ]; then
		case "$theme" in
		dark)
			recolor_icons dark
			;;
		light)
			recolor_icons light
			;;
		*)
			recolor_icons dark
			;;
		esac
	fi

}

main "$@"
