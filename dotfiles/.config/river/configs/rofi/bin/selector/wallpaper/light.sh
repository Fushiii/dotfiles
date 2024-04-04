#!/usr/bin/env cached-nix-shell
#! nix-shell -i bash -p imagemagick

export river_dir="${HOME}/.config/river"
export river_config_dir="${river_dir}/configs"
export river_rofi_config_dir="${river_config_dir}/rofi"
export river_config_flavours="${river_config_dir}/flavours/config.toml"
export wallpaper_cache_dir="${HOME}/.cache/wallpaper"
export river_assets_dir="${river_dir}/assets"
export river_wallpaper_dir="${river_assets_dir}/wallpaper"
export river_wallpaper_theme="${river_wallpaper_dir}/theme"
export river_wallpaper_name="${river_wallpaper_dir}/name"
export wallpaper_collection_dir="${HOME}/.wallpapers"

# Function to convert images
image_to_thumbnail() {
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

# Function to select wallpapers based on type and mode
select_wallpapers() {
    find "${wallpaper_collection_dir}/light" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0
}

# Main function
main() {
    if [ -z "${1-}" ]; then
        local wallpapers
        readarray -d '' wallpapers < <(select_wallpapers)

        mkdir -p $wallpaper_cache_dir

        # Convert images in directory and save to cache dir
        for wallpaper in "${wallpapers[@]}"; do
            image_to_thumbnail "$wallpaper"
        done

        printf '%s\0' "${wallpapers[@]}" | sort -z | while IFS= read -r -d '' A; do
            relative_image=${A#$wallpaper_collection_dir/}
            echo -en "${relative_image}\x00icon\x1f${wallpaper_cache_dir}/thumbnails/${relative_image}\n"
        done
    else
        wallpaper=$1
        wallpaper_path="$wallpaper_collection_dir/$wallpaper"
        wallpaper_extension="${wallpaper##*.}"
        wallpaper_file_name=$(basename "$wallpaper")
        wallpaper_relative_image="${wallpaper#$wallpaper_collection_dir/}"
        wallpaper_relative_image_folder="${wallpaper_relative_image%/$wallpaper_file_name}"

        echo "$wallpaper_path" >"${river_wallpaper_name}"
        echo "light" >"${river_wallpaper_theme}"
        export RECOLOR=true
        coproc (flavours -c "$river_config_flavours" apply --theme light)
    fi
}

main "$@"
