#!/usr/bin/env bash

hypr_rofi_config_dir="${HOME}/.config/hypr/configs/rofi"

rofi \
	-show drun \
	-theme ${hypr_rofi_config_dir}/rasi/launcher.rasi
