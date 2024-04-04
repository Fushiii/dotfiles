#!/usr/bin/env bash

# So that the ran scripts inherit
# our options set here. Better than sourcing a file.

set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

export hypr_dir="${HOME}/.config/hypr"
export hypr_config_dir="${hypr_dir}/configs"
export hypr_rofi_config_dir="${hypr_config_dir}/rofi"
export hypr_config_flavours="${hypr_config_dir}/flavours/config.toml"
export wallpaper_cache_dir="${HOME}/.cache/wallpaper"
export hypr_assets_dir="${hypr_dir}/assets"
export hypr_wallpaper_dir="${hypr_assets_dir}/wallpaper"
export wallpaper_collection_dir="${HOME}/.wallpapers"

# Construct path based on arguments
# This is reflected on file system at ${rofi_bin_dir}. You can run
# the scripts at a folder using something like this: ${program_name} folder script
#   bin
#   ├── launcher
#   ├── powermenu
#   └── selector
#       └── wallpaper
# Will in turn give you something like:
# ${program_name} launcher
# ${program_name} powermenu
# ${program_name} selector wallpaper
script_path=$hypr_rofi_config_dir/bin

# Loop through arguments
for arg in "$@"; do
	if [ "$arg" = "--" ]; then
		shift

		break
	fi
	script_path="$script_path/$arg"

	shift
done

script_path="${script_path}.sh"

program_name=$(basename "$0")

# Check if the script exists and is executable
if [ -x "$script_path" ]; then
	if [ -d "$script_path" ]; then
		echo "${program_name}: invalid command."

		exit 1
	fi

	"$script_path" "$@"
else
	echo "${program_name}: script not found: ${script_path}"
	notify-send "${script_path}"

	exit 1
fi
