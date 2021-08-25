Add-Type -TypeDefinition @"
using System;
using System.Diagnostics;

public class Solver
{
    public int[,] board;

    public Solver() {
        // Lazy implementation... 
        // powershell doesn't know how to initialize multidimentional arrays :(
        this.board = new int[9,9] 
        {
            {0,0,0, 0,3,0, 0,0,0},
            {0,0,1, 0,7,6, 9,4,0},
            {0,8,0, 9,0,0, 0,0,0},

            {0,4,0, 0,0,1, 0,0,0},
            {0,2,8, 0,9,0, 0,0,0},
            {0,0,0, 0,0,0, 1,6,0},

            {7,0,0, 8,0,0, 0,0,0},
            {0,0,0, 0,0,0, 4,0,2},
            {0,9,0, 0,1,0, 3,0,0}
        };
    }
    
    public void print_board() {
        for (int i = 0; i <= 8; i++) {
            if (i % 3 == 0 && i != 0) {
                Console.WriteLine("- - - - - - - - - - -");
            }

            for (int j = 0; j <= 8; j++) {
                if (j % 3 == 0 && j != 0) {
                    Console.Write("| ");
                }

                if (j == 8) {
                    Console.WriteLine(board[i, j]);
                }
                else {
                    Console.Write(board[i, j] + " ");
                }
            }
        }
    }

    private int[] find_empty() {
        for (int i = 0; i <= 8; i++) {
            for (int j = 0; j <= 8; j++) {
                if (board[i,j] == 0) {
                    return new int[] {i, j};  // row, col
                }
            }
        }
        return null;
    }

    private bool valid(int num, int[] pos) {
        // Check row
        for (int i = 0; i <= 8; i++) {
            if (board[pos[0], i] == num && pos[1] != i) {
                return false;
            }
        }

        // Check column
        for (int i = 0; i <= 8; i++) {
            if (board[i, pos[1]] == num && pos[0] != i) {
                return false;
            }
        } 

        // Check box
        int box_x = pos[1] / 3;
        int box_y = pos[0] / 3;

        for (int i = box_y*3; i <= box_y*3 + 2; i++) {
            for (int j = box_x*3; j <= box_x*3 + 2; j++) {
                if (board[i,j] == num && new int[] {i,j} != pos) {
                    return false;
                }
            }
        }

        return true;
    }

    public bool solve() {
        int row;
        int col;
        int[] find = find_empty();
        if (find == null) {
            return true;
        }
        else {
            row = find[0]; 
            col = find[1];
            //Console.Write("\rSolving... Row: " + (row+1) + ", Col: " + (col+1));
        }

        for (int i = 1; i <= 9; i++) {
            if (valid(i, find)) {
                board[row,col] = i;

                if (solve()) {
                    return true;
                }

                board[row,col] = 0;
            }
        }

        return false;
    }
}
"@

$s = [Solver]::new()

$s.print_board()
$time = Measure-Command {$s.solve()}
Write-Host ""
Write-Host "Seconds to Solve: $($time.TotalSeconds)"
Write-Host ""
Write-Host "_____________________"
$s.print_board()