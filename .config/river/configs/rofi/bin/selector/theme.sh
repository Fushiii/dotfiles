#!/usr/bin/env bash
#
# This code is released in public domain by Dave Davenport <qball@gmpclient.org>
#

##
# OS checking code as utilities could be different
##

ROFI=$(command -v rofi)
SED=$(command -v sed)
MKTEMP=$(command -v mktemp)

if [ -z "${SED}" ]; then
	echo "Did not find 'sed', script cannot continue."
	exit 1
fi
if [ -z "${MKTEMP}" ]; then
	echo "Did not find 'mktemp', script cannot continue."
	exit 1
fi
if [ -z "${ROFI}" ]; then
	echo "Did not find rofi, there is no point to continue."
	exit 1
fi

TMP_CONFIG_FILE=$(${MKTEMP}).rasi

##
# Array with parts to the found themes.
# And array with the printable name.
##
declare -a themes
declare -a theme_names

##
# Function that tries to find all installed rofi themes.
# This fills in #themes array and formats a displayable string #theme_names
##
find_themes() {
	readarray -t themes < <(find ~/.config/rofi/themes -type f -name "*.rasi")
	# Ensure theme_names is an array
	theme_names=()

	# Populate theme_names array with basename of each theme file without extension
	for theme in "${themes[@]}"; do
		theme_names+=("$(basename "${theme%.rasi}")")
	done
}

###
# Print the list out so it can be displayed by rofi.
##
create_theme_list() {
	OLDIFS=${IFS}
	IFS='|'
	for themen in ${theme_names[@]}; do
		echo "${themen}"
	done
	IFS=${OLDIFS}
}

##
# Thee indicate what entry is selected.
##
declare -i SELECTED

select_theme() {
	local MORE_FLAGS=(-dmenu -format i -no-custom -p "Theme" -markup -theme "${river_rofi_config_dir}/rasi/selector/theme.rasi" -i)
	MORE_FLAGS+=(-kb-custom-1 "Alt-a")
	MORE_FLAGS+=(-u 2,3 -a 4,5)
	local CUR="$(flavours current)"
	while true; do
		declare -i RTR
		declare -i RES
		local MESG="""Current theme: <b>${CUR}</b>"""
		THEME_FLAG=
		if [ -n "${SELECTED}" ]; then
			THEME_FLAG="-theme ${TMP_CONFIG_FILE}"
			cat "${river_rofi_config_dir}/rasi/selector/theme.rasi" "${themes[${SELECTED}]}" >"${TMP_CONFIG_FILE}"
		fi
		RES=$(create_theme_list | ${ROFI} ${THEME_FLAG} ${MORE_FLAGS[@]} -cycle -selected-row "${SELECTED}" -mesg "${MESG}")
		RTR=$?

		SELECTED=${RES}
		CUR=${theme_names[${RES}]}

		if [ "${RTR}" = 10 ]; then
			return 0
		elif [ "${RTR}" = 1 ]; then
			return 1
		elif [ "${RTR}" = 65 ]; then
			return 1
		fi
	done
}

############################################################################################################
# Actual program execution
###########################################################################################################
##
# Find all themes
##
find_themes

##
# Do check if there are themes.
##
if [ ${#themes[@]} = 0 ]; then
	${ROFI} -e "No themes found."
	exit 0
fi

##
# Create copy of config to play with in preview
##

##
# Show the themes to user.
##
if select_theme && [ -n "${SELECTED}" ]; then
	scheme=$(basename "${themes[${SELECTED}]}")
	scheme_slug="${scheme%.*}"
	export RECOLOR_ALL=true
	flavours -c "${river_config_flavours}" apply "${scheme_slug}"
fi

##
# Remove temp. config.
##
rm -- "${TMP_CONFIG_FILE}"
