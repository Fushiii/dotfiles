package main

import (
	"os/exec"
	"sync"
)

import (
	"init/subpackages/variables"
)

const (
	MAP      = "map"
	NORMAL   = "normal"
	MAPP     = "map-pointer"
	SPAWN    = "spawn"
	RIVERCTL = "riverctl"
)

// mouseBindings function ﳑ Bindings for mouse
func mouseBindings(mwg *sync.WaitGroup) {
	allCMDs := []*exec.Cmd{
		exec.Command(RIVERCTL, MAPP, NORMAL, "Super", "BTN_LEFT", "move-view"),
		exec.Command(RIVERCTL, MAPP, NORMAL, "Super", "BTN_RIGHT", "resize-view"),
	}

	runner(allCMDs)

	mwg.Done()
}

// keyBindings function ﳑ setting bindings for keyboard
func keyBindings(mwg *sync.WaitGroup) {

	// term := "maiden launch term"
	term := "kitty -c " + variables.RiverConfigVar.Kitty + "/kitty.conf"
	browser := "maiden launch browser"

	launch_path := variables.RiverConfigVar.Rofi + "/launch.sh "
	launch_selector_path := launch_path + "selector "

	// List of Keybinings
	allCMDs := []*exec.Cmd{
		// river
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Shift", "R", SPAWN, variables.RiverConfigVar.Path+"/init"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Shift", "Q", "exit"),

		// exec.Command(RIVERCTL, MAP, NORMAL, "Super", "Return", SPAWN, term),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "Return", SPAWN, term),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "W", SPAWN, browser),

		// Launchers
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "D", SPAWN, launch_path+"launcher"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "X", SPAWN, launch_path+"powermenu"),
		// Selectors
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "T", SPAWN, launch_selector_path+"wallpaper"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Shift", "T", SPAWN, launch_selector_path+"theme"),

		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "B", SPAWN, launch_selector_path+"bluetooth"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "N", SPAWN, launch_selector_path+"network"),

		// view focus control
		// exec.Command(RIVERCTL, MAP, NORMAL, "Super+Shift", "J", "focus-view", "next"),
		// exec.Command(RIVERCTL, MAP, NORMAL, "Super+Shift", "K", "focus-view", "previous"),

		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "J", "focus-view", "down"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "K", "focus-view", "up"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "L", "focus-view", "right"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "H", "focus-view", "left"),

		// bump focused view to the top of the stack
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "Z", "zoom"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "C", "close"),

		// output focus control
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "Period", "focus-output", "next"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "Comma", "focus-output", "previous"),

		// send view to output
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Shift", "Period", "send-to-output", "next"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Shift", "Comma", "send-to-output", "previous"),

		// resize the main ratio of rivertile
		// exec.Command(RIVERCTL, MAP, NORMAL, "Super", "H", "send-layout-cmd", "rivertile", "main-ratio -0.05"),
		// exec.Command(RIVERCTL, MAP, NORMAL, "Super", "L", "send-layout-cmd", "rivertile", "main-ratio +0.05"),

		// change the amount of views in main in rivertile
		// exec.Command(RIVERCTL, MAP, NORMAL, "Super+Alt", "H", "rivertile", "main-count +1"),
		// exec.Command(RIVERCTL, MAP, NORMAL, "Super+Alt", "L", "rivertile", "main-count -1"),
		// exec.Command(RIVERCTL, MAP, NORMAL, "Super+Alt", "H", "send-layout-cmd", "rivertile", "main-location top"),
		// exec.Command(RIVERCTL, MAP, NORMAL, "Super+Alt", "L", "send-layout-cmd", "rivertile", "main-location left"),

		// // move views
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Shift", "H", "move", "left", "100"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Shift", "J", "move", "down", "100"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Shift", "K", "move", "up", "100"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Shift", "L", "move", "right", "100"),
		//
		// Snap views
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Alt+Control", "H", "snap", "left"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Alt+Control", "J", "snap", "down"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Alt+Control", "K", "snap", "up"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Alt+Control", "L", "snap", "right"),

		// move views
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Alt+Shift", "H", "resize", "horizontal -100"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Alt+Shift", "J", "resize", "vertical 100"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Alt+Shift", "K", "resize", "vertical -100"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super+Alt+Shift", "L", "resize", "horizontal 100"),

		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "Space", "toggle-float"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "F", "toggle-fullscreen"),

		// Change layout orientation
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "Up", "send-layout-cmd", "rivertile", "main-location top"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "Right", "send-layout-cmd", "rivertile", "main-location right"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "Down", "send-layout-cmd", "rivertile", "main-location bottom"),
		exec.Command(RIVERCTL, MAP, NORMAL, "Super", "Left", "send-layout-cmd", "rivertile", "main-location left"),

		// media keys
		// exec.Command(RIVERCTL, MAP, NORMAL, "None", "XF86AudioMedia", SPAWN, "playerctl play-pause"),
		// exec.Command(RIVERCTL, MAP, NORMAL, "None", "XF86AudioPlay", SPAWN, "playerctl play-pause"),
		// exec.Command(RIVERCTL, MAP, NORMAL, "None", "XF86AudioPrev", SPAWN, "playerctl previous"),
		// exec.Command(RIVERCTL, MAP, NORMAL, "None", "XF86AudioNext", SPAWN, "playerctl next"),

		// volume keys
		exec.Command(
			RIVERCTL,
			MAP,
			NORMAL,
			"None",
			"XF86AudioRaiseVolume",
			SPAWN,
			"pactl set-sink-volume @DEFAULT_SINK@ +5%",
		),
		exec.Command(
			RIVERCTL,
			MAP,
			NORMAL,
			"None",
			"XF86AudioLowerVolume",
			SPAWN,
			"pactl set-sink-volume @DEFAULT_SINK@ -5%",
		),
		exec.Command(RIVERCTL, MAP, NORMAL, "None", "XF86AudioMute", SPAWN, "pactl set-sink-mute @DEFAULT_SINK@ toggle"),

		// brightness keys
		exec.Command(RIVERCTL, MAP, NORMAL, "None", "XF86MonBrightnessUp", SPAWN, "brightnessctl s 5+"),
		exec.Command(RIVERCTL, MAP, NORMAL, "None", "XF86MonBrightnessDown", SPAWN, "brightnessctl s 5-"),
	}
	runner(allCMDs)
	mwg.Done()
}
