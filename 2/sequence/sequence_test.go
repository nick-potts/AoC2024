package sequence

import "testing"

func TestProcessLine(t *testing.T) {
	tests := []struct {
		input string
		want  int
	}{
		// Basic cases from problem description
		{"7 6 4 2 1", 1}, // Safe: decreasing by 1-2
		{"1 2 7 8 9", 0}, // Unsafe: 2->7 jumps by 5
		{"9 7 6 2 1", 0}, // Unsafe: 6->2 drops by 4
		{"1 3 2 4 5", 2}, // Safe after removing 3
		{"8 6 4 4 1", 2}, // Safe after removing one 4
		{"1 3 6 7 9", 1}, // Safe: increasing by 2-3

		// Additional test cases
		{"5 4 3 2 1", 1}, // Safe: decreasing by 1
		{"1 2 3 4 5", 1}, // Safe: increasing by 1
		{"1 3 5 7 9", 1}, // Safe: increasing by 2
		{"1 4 6 8 9", 1}, // Safe: increasing by 2-3
		{"9 8 7 6 5", 1}, // Safe: decreasing by 1
		{"9 6 4 2 1", 1}, // Safe: decreasing by 2-3
	}

	for _, tt := range tests {
		got, err := ProcessLine(tt.input)
		if err != nil {
			t.Fatal(err)
		}
		if got != tt.want {
			t.Errorf("processLine(%q) = %d, want %d", tt.input, got, tt.want)
		}
	}
}
