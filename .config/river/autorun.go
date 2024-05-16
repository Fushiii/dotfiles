package main

import (
	"init/subpackages/theme"
	"init/subpackages/variables"
	"init/subpackages/zooom"
)

func autorun() {
	zooom.RunOnce(variables.RiverConfigVar.Path+"/assets/gtk/theme/apply.sh", "check")
	zooom.RunOnce(variables.RiverConfigVar.Path+"/assets/gtk/cursors/apply.sh", "check")
	zooom.RunOnce(variables.RiverConfigVar.Path+"/assets/gtk/icons/apply.sh", "check")
	zooom.RunOnce(variables.RiverConfigVar.Path+"/assets/wallpaper/apply.sh", "check")

	var base16 theme.Theme
	base16.GetTheme(variables.RiverConfigVar.Path + "/theme.yaml")

	zooom.ReRun(
		"river-tag-overlay",
		"--background-colour", "0x"+base16.Colors.Base00,
		"--border-colour", "0x"+base16.Colors.Base01,
		"--square-active-background-colour", "0x"+base16.Colors.Base08,
		"--square-active-border-colour", "0x"+base16.Colors.Base0B,
		"--square-active-occupied-colour", "0x"+base16.Colors.Base0B,
		"--square-inactive-background-colour", "0x"+base16.Colors.Base02,
		"--square-inactive-border-colour", "0x"+base16.Colors.Base04,
		"--square-inactive-occupied-colour", "0x"+base16.Colors.Base04,
		"--square-urgent-background-colour", "0x"+base16.Colors.Base0A,
		"--square-urgent-border-colour", "0x"+base16.Colors.Base0C,
		"--square-urgent-occupied-colour", "0x"+base16.Colors.Base0C,
	)

	zooom.ReRun(
		"rivertile",
		"-view-padding",
		"05",
		"-outer-padding",
		"05",
	)

	zooom.Run("wlr-randr", "--output", "eDP-1", "--off")

	// zooom.ReRun("mako", "-c", variables.RiverConfigVar.Mako)

	//zooom.RunOnce(
	//	"wl-paste",
	//	"-t",
	//	"text",
	//	"--watch",
	//	"clipman",
	//	"store",
	//)

	//zooom.RunOnce(
	//	"wl-paste",
	//	"-p",
	//	"-t",
	//	"text",
	//	"--watch",
	//	"clipman",
	//	"store",
	//	"-P",
	//	"store",
	//	"~/.local/share/clipman-primary.json",
	//)

}
