package main

import (
	"strconv"
	"sync"
)

import (
	"init/subpackages/notify"
	"init/subpackages/variables"
	"init/subpackages/zooom"
)

// main function Everything goes through here!
func main() {
	// for concurrency
	var mwg sync.WaitGroup
	mwg.Add(7) // if the number of gorouines under increased, this number should increase as well

	go keyBindings(&mwg)
	go mouseBindings(&mwg)

	// coloring and stuff
	go setTheme(&mwg)

	// river's settings
	go setOptions(&mwg)
	go applyToTags(&mwg)
	go inputs(&mwg)

	autorun()

	err := zooom.WriteToLock(strconv.Itoa(variables.InitVar.ParentPID))

	if err != nil {
		notify.Notify("RunOnce", "Failed to write parent process pid to lockfile.")
	}

	// rest of concurrency stuff
	mwg.Wait()
}
