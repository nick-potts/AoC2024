package main

import (
	"bufio"
	"fmt"
	"main/sequence"
	"os"
)

func main() {
	file, err := os.Open("input.txt")
	if err != nil {
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	safeCount := 0
	safeWithRemovedCount := 0
	for scanner.Scan() {
		safe, err := sequence.ProcessLine(scanner.Text())
		if err != nil {
			fmt.Println("Error processing line:", err)
			return
		}
		if safe == 1 {
			safeCount++
		}
		if safe >= 1 {
			safeWithRemovedCount++
		}
	}

	fmt.Println("Safe count:", safeCount)
	fmt.Println("Safe with removed count:", safeWithRemovedCount)

	return
}
