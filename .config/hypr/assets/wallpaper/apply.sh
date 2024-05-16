#!/usr/bin/env bash
csv_file="$HOME/.config/hypr/configs/taste/wallpaper.csv"
hypr_wallpaper_color_path="$HOME/.config/hypr/assets/wallpaper/color"
hypr_wallpaper_recolor_path="$HOME/.config/hypr/assets/wallpaper/status"
hypr_wallpaper_theme_path="$HOME/.config/hypr/assets/wallpaper/theme"
hypr_wallpaper_name_path="$HOME/.config/hypr/assets/wallpaper/name"
wallpaper_assets_path="$HOME/.icons/assets/wallpaper"
wallpaper_path="$HOME/.config/hypr/assets/wallpaper/wallpaper"
wallpaper_cache_path="$HOME/.cache/wallpaper"
wallpaper_collection_dir="${HOME}/.wallpapers"

colors=$(awk -F',' 'NR==2 {print}' "$csv_file")
sanitized_color=$(echo "${colors}" | tr '[:upper:]' '[:lower:]' | tr -d '\r\n[:space:],#')
IFS=',' read -ra color <<<"$colors"

# Check if the right wallpaper are in place.
# If not, will remove the link and put the right one in place.
check_link() {
	local theme="$1"
	local image="$2"
	image_file_name=$(basename "$image")
	image_relative="${image#$wallpaper_collection_dir/}"

	if [ -z "$image" ]; then
		echo "Image is a needed argument."
		exit 1
	else
		if [ ! -f "$image" ]; then
			echo "The image provided does not exist."
			exit 1
		fi
	fi

	cached_wallpaper="$wallpaper_cache_path/$theme/$sanitized_color/$image_relative"

	if [ -L "$wallpaper_path" ]; then
		link_target=$(readlink "$wallpaper_path")
		if [ "$link_target" != "$cached_wallpaper" ]; then
			unlink "$wallpaper_path"
			ln -s "$cached_wallpaper" "$wallpaper_path"
		fi
		# Check if the link points to a non-existent target directory
		if [ -n "$link_target" ] && [ ! -d "$link_target" ]; then
			check_wallpaper $theme $image
		fi
	elif [ ! -e "$wallpaper_path" ]; then
		ln -s "$cached_wallpaper" "$wallpaper_path"
	fi
}

# Check if the wallpaper are in cache / exists.
# If not, will recolor and cache them for usage.
check_wallpaper() {
	local theme="$1"
	local image="$2"
	image_file_name=$(basename "$image")
	image_relative="${image#$wallpaper_collection_dir/}"
	image_relative_folder="${image_relative%/$image_file_name}"

	cached_wallpaper_dir="$wallpaper_cache_path/$theme/$sanitized_color/$image_relative_folder"
	mkdir -p "$cached_wallpaper_dir"
	cached_wallpaper="$cached_wallpaper_dir/$image_file_name"

	if [ ! -f "$cached_wallpaper" ]; then

		ImageColorizer "${image}" "$cached_wallpaper" -p "${color[@]}" --no_quantize

		echo "$color" >"$hypr_wallpaper_color_path"
		echo "$theme" >"$hypr_wallpaper_theme_path"
		echo "$image" >"$hypr_wallpaper_name_path"
	fi
	swww img "$cached_wallpaper"
}

recolor_wallpaper() {
	local theme="$1"
	local image="$2"

	if [ -f "$hypr_wallpaper_recolor_path" ]; then
		rm "$hypr_wallpaper_recolor_path"
		check_wallpaper $theme $image
	else
		if [ -f "$hypr_wallpaper_color_path" ]; then
			hypr_wallpaper_color=$(cat "$hypr_wallpaper_color_path")

			if [ "$hypr_wallpaper_color" != "$color" ]; then
				echo "Replacing the wallpaper as colors do no coincide: $hypr_wallpaper_color $color"
				check_wallpaper $theme $image
			fi

		else
			check_wallpaper $theme $image
		fi
	fi

	check_link $theme $image
}

main() {
	local theme="dark"
	image=$(cat "$hypr_wallpaper_name_path")

	while [[ $# -gt 0 ]]; do
		case "$1" in
		--theme)
			shift
			theme="$1"
			;;
		check)
			shift
			previous_theme=$(cat "$hypr_wallpaper_theme_path")
			pkill swww
			swww init
			swww clear
			check_link $previous_theme $image
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
			recolor_wallpaper dark $image
			;;
		light)
			recolor_wallpaper light $image
			;;
		*)
			recolor_wallpaper dark $image
			;;
		esac
	fi

}

main "$@"
