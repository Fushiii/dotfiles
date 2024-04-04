package notify

import (
	"errors"
	"os/exec"
	"path/filepath"
)

func pathAbs(path string) string {
	var err error
	var abs string

	if path != "" {
		abs, err = filepath.Abs(path)
		if err != nil {
			abs = path
		}
	}

	return abs
}

func Notify(title string, message string, appIcons ...string) error {

	var appIcon string

	if len(appIcons) > 0 {
		appIcon = pathAbs(appIcons[0])
	}

	cmd := func() error {
		send, err := exec.LookPath("notify-send")
		if err != nil {
			return err
		}
		c := exec.Command(send, title, message, "-i", appIcon)

		return c.Run()
	}

	e := cmd()
	if e != nil {
		return errors.New("notify: " + e.Error())
	}

	return nil
}
