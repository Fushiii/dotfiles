#!/usr/bin/env cached-nix-shell
#! nix-shell -i bash -p imagemagick

hypr_dir="${HOME}/.config/hypr"
hypr_config_dir="${hypr_dir}/configs"
hypr_rofi_config_dir="${hypr_config_dir}/rofi"
hypr_config_flavours="${hypr_config_dir}/flavours/config.toml"
wallpaper_cache_dir="${HOME}/.cache/wallpaper"
hypr_assets_dir="${hypr_dir}/assets"
hypr_wallpaper_dir="${hypr_assets_dir}/wallpaper"
wallpaper_collection_dir="${HOME}/.wallpapers"

# Function to convert images
make_thumbnail() {
	local image="$1"
	local file_name=$(basename "$image")
	local relative_image="${image#$wallpaper_collection_dir/}"
	local relative_image_folder="${relative_image%/$file_name}"

	if [ ! -f "${wallpaper_cache_dir}/thumbnails/${relative_image}" ]; then
		if [ "$relative_image" != "$relative_image_folder" ]; then
			mkdir -p "${wallpaper_cache_dir}/thumbnails/${relative_image_folder}"
		fi
		convert -strip "$image" -thumbnail 512x512^ -gravity center -extent 512x512 "${wallpaper_cache_dir}/thumbnails/${relative_image}"

	fi
}

find_wallpapers() {
	local directory="$1"
	find "$directory" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0
}

# Main function
main() {
	if [ -z "${1-}" ]; then
		local wallpapers
		readarray -d '' wallpapers < <(find_wallpapers "${wallpaper_collection_dir}")

		readarray -d '' dark_wallpapers < <(find_wallpapers "${wallpaper_collection_dir}/dark")
		readarray -d '' light_wallpapers < <(find_wallpapers "${wallpaper_collection_dir}/light")

		for target in "${dark_wallpapers[@]}" "${light_wallpapers[@]}"; do
			for i in "${!wallpapers[@]}"; do
				if [[ ${wallpapers[i]} = $target ]]; then
					unset 'wallpapers[i]'
				fi
			done
		done

		wallpapers=("${wallpapers[@]}")

		mkdir -p $wallpaper_cache_dir

		# Convert images in directory and save to cache dir
		for wallpaper in "${wallpapers[@]}"; do
			make_thumbnail "$wallpaper"
		done

		printf '%s\0' "${wallpapers[@]}" | sort -z | while IFS= read -r -d '' A; do
			relative_image=${A#$wallpaper_collection_dir/}
			echo -en "${relative_image}\x00icon\x1f${wallpaper_cache_dir}/thumbnails/${relative_image}\n"
		done
	else
		# TODO: copy the wallpaper to cache, fill the
		# staus files and also an extra file to check wheter
		# the apply.sh script should recolor or not do anything.
		# selected_wallpaper_path="$wallpaper_collection_dir/$1"
		# selected_wallpaper_extension="${selected_wallpaper_path##*.}"
		# wallpaper_path="${hypr_wallpaper_dir}/wallpaper.${selected_wallpaper_extension}"
		# rm -rf "${hypr_wallpaper_dir}"/wallpaper.*
		# cp $selected_wallpaper_path $wallpaper_path
		# swww img $wallpaper_path
		# coproc (flavours generate auto "${wallpaper_path}" && flavours -c "$hypr_config_flavours" apply generated)

		wallpaper=$1
		wallpaper_path="$wallpaper_collection_dir/$wallpaper"
		wallpaper_extension="${wallpaper##*.}"
		wallpaper_file_name=$(basename "$wallpaper")
		wallpaper_relative_image="${wallpaper#$wallpaper_collection_dir/}"
		wallpaper_relative_image_folder="${wallpaper_relative_image%/$wallpaper_file_name}"

		echo "$wallpaper_path" >"${hypr_wallpaper_name}"
		ln -sf $wallpaper_path "${hypr_wallpaper_dir}/wallpaper"
		swww img "${hypr_wallpaper_dir}/wallpaper"
		echo "all" >"${hypr_wallpaper_theme}"
		coproc (flavours generate auto "${wallpaper_path}" && flavours -c "$hypr_config_flavours" apply generated)

	fi
}

main "$@"
