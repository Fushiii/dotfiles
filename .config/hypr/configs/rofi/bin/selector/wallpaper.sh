#!/usr/bin/env bash

hypr_rofi_config_dir="${HOME}/.config/hypr/configs/rofi"
rofi_command="rofi -show all -theme ${hypr_rofi_config_dir}/rasi/selector/wallpaper.rasi"

# Main function
main() {
	$rofi_command
}

main "$@"
