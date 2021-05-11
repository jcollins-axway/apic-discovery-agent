package main

import (
	"fmt"
	"os"

	// CHANGE_HERE - Change the import path(s) below to reference packages correctly
	"github.com/jcollins-axway/apic-discovery-agent/pkg/cmd"
)

func main() {
	if err := cmd.RootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
