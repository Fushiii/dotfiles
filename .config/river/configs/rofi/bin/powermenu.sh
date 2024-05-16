#!/usr/bin/env bash
config_dir="$HOME/.config/river/config/rofi"

# Options
hibernate='󰒲'
shutdown='󰐥'
suspend='󰜗'
reboot='󰑓'
logout='󰍃'
lock='󰌾'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-theme ${river_rofi_config_dir}/rasi/powermenu.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$hibernate\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ $1 == '--shutdown' ]]; then
		systemctl poweroff
	elif [[ $1 == '--reboot' ]]; then
		systemctl reboot
	elif [[ $1 == '--hibernate' ]]; then
		systemctl hibernate
	elif [[ $1 == '--suspend' ]]; then
		systemctl suspend
	elif [[ $1 == '--logout' ]]; then
		riverctl exit
	fi
}

chosen="$(run_rofi)"
case ${chosen} in
$shutdown)
	run_cmd --shutdown
	;;
$reboot)
	run_cmd --reboot
	;;
$hibernate)
	run_cmd --hibernate
	;;
$lock)
	if [[ -x '/usr/bin/betterlockscreen' ]]; then
		betterlockscreen -l
	fi
	;;
$suspend)
	run_cmd --suspend
	;;
$logout)
	run_cmd --logout
	;;
esac
