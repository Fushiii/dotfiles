package main

import (
	"bytes"
	"fmt"
	"os/exec"
	"sync"
)
import (
	"init/subpackages/variables"
)

func getGtkVar(pattern string) (string, error) {
	// Command to grep the gtk-theme-name from settings.ini file
	grepCmd := exec.Command("grep", pattern, variables.ConfigVar.Path+"/gtk-3.0/settings.ini")
	// Command to extract the theme name using sed
	sedCmd := exec.Command("sed", "s/.*\\s*=\\s*//")

	// Combine standard output and standard error
	grepOutput, err := grepCmd.CombinedOutput()
	if err != nil {
		return "", fmt.Errorf("error running grep command: %v", err)
	}

	sedCmd.Stdin = bytes.NewReader(grepOutput)

	sedOutput, err := sedCmd.CombinedOutput()
	if err != nil {
		return "", fmt.Errorf("error running sed command: %v", err)
	}

	return string(sedOutput), nil
}

func setTheme(mwg *sync.WaitGroup) {
	defer mwg.Done() // Ensure that Done() is called when setTheme() exits

	iconThemeName, err := getGtkVar("gtk-icon-theme-name")
	themeName, _ := getGtkVar("gtk-theme-name")
	cursorThemeName, _ := getGtkVar("gtk-cursor-theme-name")
	if err != nil {
		// Handle error
		panic(err)
	}
	gtkCMDs := []*exec.Cmd{
		exec.Command("configure-gtk", "icon", iconThemeName),
		exec.Command("configure-gtk", "cursor", cursorThemeName),
		exec.Command("configure-gtk", "gtk", themeName),
	}

	allCMDs := []*exec.Cmd{
		exec.Command(RIVERCTL, "background-color", "0x"+rosePine["base"]),
		exec.Command(RIVERCTL, "border-color-focused", "0x"+rosePine["rose"]),
		exec.Command(RIVERCTL, "border-color-unfocused", "0x"+rosePine["base"]),
		exec.Command(RIVERCTL, "border-color-urgent", "0x"+rosePine["love"]),
		exec.Command(RIVERCTL, "border-width", "1"),
		exec.Command(RIVERCTL, "xcursor-theme", "'cutefish-light'", "24"),
	}

	runner(gtkCMDs)
	runner(allCMDs)

	mwg.Done()
}

// TODO: turn this into a base16 map

var rosePine = map[string]string{
	"base":    "191724",
	"surface": "1f1d2e",
	"overlay": "26233a",
	"muted":   "6e6a86",
	"subtle":  "908caa",
	"text":    "e0def4",
	"love":    "eb6f92",
	"gold":    "f6c177",
	"rose":    "ebbcba",
	"pine":    "31748f",
	"foam":    "9ccfd8",
	"iris":    "c4a7e7",
	"hlLow":   "21202e",
	"hlMed":   "403d52",
	"hlHigh":  "524f67",
}
var gruvDark = map[string]string{
	"base":    "191724",
	"surface": "1f1d2e",
	"overlay": "26233a",
	"muted":   "6e6a86",
	"subtle":  "908caa",
	"text":    "e0def4",
	"love":    "eb6f92",
	"gold":    "f6c177",
	"rose":    "ebbcba",
	"pine":    "31748f",
	"foam":    "9ccfd8",
	"iris":    "c4a7e7",
	"hlLow":   "21202e",
	"hlMed":   "403d52",
	"hlHigh":  "524f67",
}
