package main

import (
	"fmt"
	"time"
)

type Board [9][9]int

func print_board(b *Board) {
	for i := 0; i <= 8; i++ {
		if i%3 == 0 && i != 0 {
			fmt.Println("- - - + - - - + - - -")
		}

		for j := 0; j <= 8; j++ {
			if j%3 == 0 && j != 0 {
				fmt.Print("| ")
			}

			if j == 8 {
				fmt.Println(b[i][j])
			} else {
				fmt.Print(b[i][j], " ")
			}
		}
	}
}

func find_empty(b *Board) (int, int, bool) {
	for i := 0; i <= 8; i++ {
		for j := 0; j <= 8; j++ {
			if b[i][j] == 0 {
				return i, j, true
			}
		}
	}
	return 0, 0, false
}

func valid(b *Board, num int, row int, col int) bool {
	// Check row
	for i := 0; i <= 8; i++ {
		if b[row][i] == num && col != i {
			return false
		}
	}

	// Check column
	for i := 0; i <= 8; i++ {
		if b[i][col] == num && row != i {
			return false
		}
	}

	// Check box
	box_x := col / 3
	box_y := row / 3

	for i := box_y * 3; i < box_y*3+3; i++ {
		for j := box_x * 3; j < box_x*3+3; j++ {
			if b[i][j] == num && row != i && col != j {
				return false
			}
		}
	}

	return true
}

func solve(b *Board) bool {
	row, col, found := find_empty(b)
	if !found {
		return true
	}

	for i := 1; i <= 9; i++ {
		if valid(b, i, row, col) {
			b[row][col] = i

			if solve(b) {
				return true
			}

			b[row][col] = 0
		}
	}

	return false
}

func main() {
	board := &Board{
		{0, 0, 0, 0, 3, 0, 0, 0, 0},
		{0, 0, 1, 0, 7, 6, 9, 4, 0},
		{0, 8, 0, 9, 0, 0, 0, 0, 0},

		{0, 4, 0, 0, 0, 1, 0, 0, 0},
		{0, 2, 8, 0, 9, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 1, 6, 0},

		{7, 0, 0, 8, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 4, 0, 2},
		{0, 9, 0, 0, 1, 0, 3, 0, 0},
	}

	print_board(board)

	startTime := time.Now()
	solve(board)
	elapsedTime := time.Since(startTime)

	fmt.Println("")
	fmt.Println("Seconds to solve:", elapsedTime.Seconds())
	fmt.Println("")
	fmt.Println("_____________________")
	print_board(board)
}
