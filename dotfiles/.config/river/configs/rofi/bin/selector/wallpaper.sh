#!/usr/bin/env bash

rofi_command="rofi -show all -theme ${river_rofi_config_dir}/rasi/selector/wallpaper.rasi"

# Main function
main() {
    $rofi_command
}

main "$@"
