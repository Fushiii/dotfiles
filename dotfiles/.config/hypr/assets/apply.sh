#!/usr/bin/env bash

# Function to recolor icons based on the provided color and theme
recolor_wallpaper() {
    local theme="$1"

    # Recolor the icons based on the provided theme.
    case "$theme" in
        dark)
            ImageColorizer ~/.config/hypr/assets/wallpaper/dark.png ~/.config/hypr/assets/wallpaper.png -x --no_quantize
            ;;
        light)
            ImageColorizer ~/.config/hypr/assets/wallpaper/light.png ~/.config/hypr/assets/wallpaper.png -x --no_quantize
            ;;
        *)
            ImageColorizer ~/.config/hypr/assets/wallpaper/dark.png ~/.config/hypr/assets/wallpaper.png -x --no_quantize
            ;;
    esac

}


main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --theme)
                shift
                theme="$1"
                ;;
            *)
                echo "Unknown argument: $1"
                exit 1
                ;;
        esac
        shift
    done

    # Perform actions based on the provided theme (dark/light)
    case "$theme" in
        dark)
            recolor_wallpaper dark
            ;;
        light)
            recolor_wallpaper light
            ;;
        *)
            recolor_wallpaper dark
            ;;
    esac

    # Kill hyprpaper
    # This is needed because
    # hyprpaper does not notice changes.
    pkill hyprpaper
    
    # Run hyprpaper and disown it.
    nohup hyprpaper </dev/null >/dev/null 2>&1 & # completely detached from terminal
}

main
