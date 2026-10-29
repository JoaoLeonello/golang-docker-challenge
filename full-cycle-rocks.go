package main

import "os"

// os em vez de fmt: fmt arrasta reflection e deixa o binário ~0,7MB maior
func main() {
	os.Stdout.WriteString("Full Cycle Rocks!\n")
}
