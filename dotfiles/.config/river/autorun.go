package main

import (
	"init/subpackages/variables"
	"init/subpackages/zooom"
)

func autorun() {
	zooom.AsyncRun(variables.RiverConfigVar.Path+"/assets/gtk/theme/apply.sh", "check")
	zooom.AsyncRun(variables.RiverConfigVar.Path+"/assets/gtk/cursors/apply.sh", "check")
	zooom.AsyncRun(variables.RiverConfigVar.Path+"/assets/gtk/icons/apply.sh", "check")
	zooom.AsyncRun(variables.RiverConfigVar.Path+"/assets/wallpaper/apply.sh", "check")

	zooom.Run(
		"rivertile",
		"-view-padding",
		"05",
		"-outer-padding",
		"05",
	)
	// Other things depend on this.
	zooom.RunOnce("wlr-randr", "--output", "eDP-1", "--off")
	zooom.RunOnce("river-tag-overlay")

	zooom.Run(RIVERCTL, "keyboard-layout", "br")

	zooom.RunOnce("systemctl", "--user", "start", "notifier")
	zooom.RunOnce("eww", "open", "-c", variables.RiverConfigVar.Eww, "rightbar")

	zooom.RunOnce(
		"wl-paste",
		"-t",
		"text",
		"--watch",
		"clipman",
		"store",
	)

	zooom.RunOnce(
		"wl-paste",
		"-p",
		"-t",
		"text",
		"--watch",
		"clipman",
		"store",
		"-P",
		"store",
		"~/.local/share/clipman-primary.json",
	)

}
