package variables

import (
	"os"
)
import "init/subpackages/notify"

const (
	riverConfigDir  = "/river"
	riverConfigsDir = riverConfigDir + "/configs"
)

type Config struct {
	Path string
}

var ConfigVar = Config{
	Path: userConfigDir(),
}

type Cache struct {
	Path string
}

var CacheVar = Cache{
	Path: userCacheDir() + "/init",
}

type RiverConfig struct {
	Path  string
	Rofi  string
	Eww   string
	Kitty string
	Mako  string
}

var RiverConfigVar = RiverConfig{
	Path:  ConfigVar.Path + riverConfigDir,
	Rofi:  ConfigVar.Path + riverConfigsDir + "/rofi",
	Eww:   ConfigVar.Path + riverConfigsDir + "/eww",
	Kitty: ConfigVar.Path + riverConfigsDir + "/kitty",
	Mako:  ConfigVar.Path + riverConfigsDir + "/mako/config",
}

type Init struct {
	ParentPID int
}

var InitVar = Init{
	ParentPID: os.Getppid(),
}

func userCacheDir() string {
	dir, err := os.UserCacheDir()

	if err != nil {
		notify.Notify("Init", "failed to get the user cache directory.")

		panic(err)
	}
	return dir
}

func userConfigDir() string {
	dir, err := os.UserConfigDir()

	if err != nil {
		notify.Notify("Init", "failed to get the user configuration directory.")

		panic(err)
	}
	return dir
}
