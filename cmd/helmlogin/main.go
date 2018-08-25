package main

import (
	"fmt"
	"github.com/spf13/cobra"
	"golang.org/x/crypto/ssh/terminal"
	"os"
	"syscall"
)

type (
	loginCmd struct{}
)

var (
	globalUsage = `Helm plugin to authenticate against ChartMuseum

Examples:

  $ TODO
`
)

func newLoginCmd(args []string) *cobra.Command {
	lc := &loginCmd{}
	cmd := &cobra.Command{
		Use:          "helm login",
		Short:        "Helm plugin to authenticate against ChartMuseum",
		Long:         globalUsage,
		SilenceUsage: true,
		RunE: func(cmd *cobra.Command, args []string) error {
			return lc.login()
		},
	}
	f := cmd.Flags()
	f.Parse(args)
	return cmd
}

func (lc *loginCmd) login() error {
	fmt.Print("Enter Password: ")
	bytePassword, err := terminal.ReadPassword(int(syscall.Stdin))
	if err != nil {
		return err
	}
	fmt.Println("\nPassword typed: " + string(bytePassword))
	return nil
}

func main() {
	cmd := newLoginCmd(os.Args[1:])
	if err := cmd.Execute(); err != nil {
		os.Exit(1)
	}
}
