package views

import (
	tea "github.com/charmbracelet/bubbletea"
)

type RootViewModel struct {
	model tea.Model
}

func NewRootView() RootViewModel {

	// Default to the Dashboard view model
	return RootViewModel{
		model: NewDashboardView(deps),
	}
}

func (m RootViewModel) Init() tea.Cmd {
	return m.model.Init()
}

func (m RootViewModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case ui.SwitchToMsg:
		m.model = msg.Model
		return m, m.model.Init()
	}

	var cmd tea.Cmd
	m.model, cmd = m.model.Update(msg)
	return m, cmd
}

func (m RootViewModel) View() string {
	return m.model.View()
}
