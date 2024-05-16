#!/usr/bin/env bash

# So that the ran scripts inherit
# our options set here. Better than sourcing a file.

set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

export river_dir="${HOME}/.config/river"
export river_config_dir="${river_dir}/configs"
export river_rofi_config_dir="${river_config_dir}/rofi"
export river_config_flavours="${river_config_dir}/flavours/config.toml"
export wallpaper_cache_dir="${HOME}/.cache/wallpaper"
export river_assets_dir="${river_dir}/assets"
export river_wallpaper_dir="${river_assets_dir}/wallpaper"
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
script_path=$river_rofi_config_dir/bin

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

	exit 1
fi
