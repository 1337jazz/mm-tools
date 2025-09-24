package views

import (
	"fmt"
	"strings"

	"github.com/1337jazz/tamion-cli/internal/config"
	"github.com/1337jazz/tamion-cli/internal/ui"
	c "github.com/1337jazz/tamion-cli/internal/ui/components"
	"github.com/charmbracelet/bubbles/table"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type DashboardViewModel struct {
	deps         *config.Dependencies
	table        table.Model
	lastSyncDate string
	uncatCount   int64
}

func NewDashboardView(deps *config.Dependencies) DashboardViewModel {

	lastSyncDate, err := deps.AccountService.GetLastSyncDate()
	if err != nil {
		panic(err)
	}

	uncatCount, err := deps.TransactionService.GetUncategorisedTransactionsCount()
	if err != nil {
		panic(err)
	}

	columns := []table.Column{
		{Title: "Options", Width: 50},
	}
	rows := []table.Row{
		{"Manage accounts"},
		{"Manage budgets"},
		{"Manage categories"},
	}

	return DashboardViewModel{
		deps:         deps,
		lastSyncDate: lastSyncDate.Format("2006-01-02 15:04:05"),
		uncatCount:   uncatCount,
		table: c.NewTable(c.TableConfig{
			Rows:    rows,
			Columns: columns,
			Height:  10,
		}),
	}
}

func (m DashboardViewModel) Init() tea.Cmd {
	return nil
}

func (m DashboardViewModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			return m, tea.Quit
		case "enter", "l":
			if m.table.Focused() {
				model := m.mapDashboardOptionToModel(m.table.SelectedRow()[0])
				return m, ui.SwitchTo(model)
			}
		}
	}

	var cmd tea.Cmd
	m.table, cmd = m.table.Update(msg)
	return m, cmd
}

func (m DashboardViewModel) View() string {
	style := lipgloss.NewStyle().Padding(1, 2, 1, 2)
	return style.Render(lipgloss.JoinVertical(
		lipgloss.Left,
		"Tamion CLI Dashboard",
		"",
		fmt.Sprintf("Last sync date: \t\t\t\t%s", m.lastSyncDate),
		fmt.Sprintf("Uncategorised transactions: \t%d", m.uncatCount),
		"\n",
		m.table.View(),
	))
}

func (m DashboardViewModel) mapDashboardOptionToModel(option string) tea.Model {
	switch {
	case strings.Contains(option, "accounts"):
		return NewAccountsListView(m.deps)
	case strings.Contains(option, "budgets"):
		return NewBudgetView(m.deps)
	case strings.Contains(option, "categories"):
		return NewCategoryListView(m.deps)
	default:
		panic("Unknown option: " + option)
	}
}
