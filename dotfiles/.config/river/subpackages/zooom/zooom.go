package zooom

import (
	"fmt"
	"os"
	"os/exec"
	"strconv"
	"strings"
)

import (
	"init/subpackages/notify"
	"init/subpackages/variables"
)

func ReadFromLock() (string, error) {
	// Open the file for reading
	file, err := os.Open(variables.CacheVar.Path + "/lock")
	if err != nil {
		fmt.Println("Error opening file:", err)
		return "", err
	}
	defer file.Close() // Close the file when we're done

	// Read data from the file
	data := make([]byte, 100) // Allocate a buffer to hold the data
	count, err := file.Read(data)
	if err != nil {
		fmt.Println("Error reading from file:", err)
		return "", err
	}

	// Convert the bytes read into a string
	str := string(data[:count])

	return str, nil
}

func WriteToLock(content string) error {
	// Open the file for writing. If the file doesn't exist, it will be created.
	file, err := os.Create(variables.CacheVar.Path + "/lock")
	if err != nil {
		fmt.Println("Error creating file:", err)
		return err
	}

	defer file.Close()

	// Write some data to the file
	_, err = file.WriteString(content)
	if err != nil {
		fmt.Println("Error writing to file:", err)

		return err
	}

	return nil
}

func RunOnce(bin string, args ...string) error {
	// Create the directory and any necessary parents
	err := os.MkdirAll(variables.CacheVar.Path, 0755)
	if err != nil {
		notify.Notify("Failed to create cache directory:", err.Error())
		return err
	}
	parentPid, err := ReadFromLock()

	// Diffent pid's, run the command again
	if parentPid != strconv.Itoa(variables.InitVar.ParentPID) {
		cmd := exec.Command(bin, args...)
		err = cmd.Start()

		if err != nil {
			errMsg := fmt.Sprintf("failed to run: %s %s", bin, strings.Join(args, " "))
			notify.Notify("Run", errMsg)

			return err
		}
	}

	return nil
}

func Run(bin string, args ...string) error {
	cmd := exec.Command(bin, args...)
	err := cmd.Start()

	if err != nil {
		errMsg := fmt.Sprintf("failed to run: %s %s", bin, strings.Join(args, " "))
		notify.Notify("Run", errMsg)

		return err
	}

	return nil
}

func AsyncRun(bin string, args ...string) error {
	// Create a channel to receive errors from the goroutine
	errChan := make(chan error)

	// Execute the command asynchronously in a goroutine
	go func() {
		cmd := exec.Command(bin, args...)
		err := cmd.Start()
		if err != nil {
			errMsg := fmt.Sprintf("%s %s", bin, strings.Join(args, " "))
			// Instead of returning the error, send it through the channel
			errChan <- fmt.Errorf(errMsg)
		}
		// Close the channel to signal that the operation is complete
		close(errChan)
	}()

	// Check for errors received from the goroutine
	for err := range errChan {
		// Handle errors here
		errMsg := fmt.Sprintf("failed to run: %s", err.Error()) // Convert error to string
		notify.Notify("Run", errMsg)
	}

	return nil
}
