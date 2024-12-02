package sequence

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
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
		safe, err := ProcessLine(scanner.Text())
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

	fmt.Println("Part 1:", safeCount)
	fmt.Println("Part 2:", safeWithRemovedCount)

	return
}
func ProcessLine(line string) (int, error) {
	numbers := strings.Split(line, " ")
	if len(numbers) < 2 {
		return 0, fmt.Errorf("Invalid input")
	}

	nums := make([]int, len(numbers))
	for i, num := range numbers {
		n, err := strconv.Atoi(num)
		if err != nil {
			return 0, err
		}
		nums[i] = n
	}

	if checkSequence(nums) {
		return 1, nil
	}
	for i := range nums {
		if checkSequence(removeItem(nums, i)) {
			return 2, nil
		}
	}
	return 0, nil
}

func checkSequence(nums []int) bool {
	increasing := nums[1] > nums[0]
	for i := 1; i < len(nums); i++ {
		if isValid(nums[i-1], nums[i], increasing) {
			continue
		}
		return false
	}

	return true
}

func isValid(first, second int, increasing bool) bool {
	if first == second {
		return false
	}

	diff := second - first
	if increasing {
		return diff >= 1 && diff <= 3
	}
	return diff <= -1 && diff >= -3
}

func removeItem(s []int, i int) []int {
	arr := make([]int, 0)
	arr = append(arr, s[:i]...)
	return append(arr, s[i+1:]...)
}
