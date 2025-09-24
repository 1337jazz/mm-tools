package main

import (
	"fmt"
	"os"

	tea "github.com/charmbracelet/bubbletea"
)

func main() {

	prog := tea.NewProgram(views.NewRootView(deps), tea.WithAltScreen())
	if _, err := prog.Run(); err != nil {
		fmt.Printf("Alas, there's been an error: %v", err)
		os.Exit(1)
	} // This is a placeholder for the main function.
}
