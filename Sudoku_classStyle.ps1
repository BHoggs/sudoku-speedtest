class Solver {
    [array[]]$board
    [void] print_board() {
        foreach ($i in 0..8) {
            if ($i % 3 -eq 0 -and $i -ne 0) {
                Write-Host "- - - - - - - - - - -"
            }

            foreach ($j in 0..8) {
                if ($j % 3 -eq 0 -and $j -ne 0) {
                    Write-Host "| " -NoNewline
                }

                if ($j -eq 8) {
                    Write-Host $this.board[$i][$j]
                }
                else {
                    Write-Host ([string]$this.board[$i][$j] + " ") -NoNewline
                }
            }
        }
    }

    [int[]] find_empty() {
        foreach ($i in 0..8) {
            foreach ($j in 0..8) {
                if ($this.board[$i][$j] -eq 0) {
                    return $i, $j  # row, col
                }
            }
        }
        return $null
    }

    [bool] valid([int]$num, [int[]]$pos) {
        # Check row
        foreach ($i in 0..8) {
            if ($this.board[$pos[0]][$i] -eq $num -and $pos[1] -ne $i) {
                return $False
            }
        }

        # Check column
        foreach ($i in 0..8) {
            if ($this.board[$i][$pos[1]] -eq $num -and $pos[0] -ne $i) {
                return $False
            }
        } 

        # Check box
        [int]$box_x = [math]::Floor($pos[1] / 3)
        [int]$box_y = [math]::Floor($pos[0] / 3)

        foreach ($i in ($box_y*3)..($box_y*3 + 2)) {
            foreach ($j in ($box_x * 3)..($box_x*3 + 2)) {
                if ($this.board[$i][$j] -eq $num -and @($i,$j) -ne $pos) {
                    return $False
                }
            }
        }

        return $True
    }

    [bool] solve() {
        [int[]]$find = $this.find_empty()
        if (-not $find) {
            return $True
        }
        else {
            $row, $col = $find
            #Write-Progress -Activity "Solving..." -CurrentOperation "Row: $($row+1), Col: $($col+1)" -PercentComplete ([math]::round($row*$col/64*100))
            #[Console]::Write("`rSolving... Row: $($row+1), Col: $($col+1)")
        }

        foreach ($i in 1..9) {
            if ($this.valid($i, $find)) {
                $this.board[$row][$col] = $i

                if ($this.solve()) {
                    return $True
                }

                $this.board[$row][$col] = 0
            }
        }

        return $False
    }
}

$s = [Solver]::new()

$s.board = @(
    @(0,0,0, 0,3,0, 0,0,0),
    @(0,0,1, 0,7,6, 9,4,0),
    @(0,8,0, 9,0,0, 0,0,0),

    @(0,4,0, 0,0,1, 0,0,0),
    @(0,2,8, 0,9,0, 0,0,0),
    @(0,0,0, 0,0,0, 1,6,0),

    @(7,0,0, 8,0,0, 0,0,0),
    @(0,0,0, 0,0,0, 4,0,2),
    @(0,9,0, 0,1,0, 3,0,0)
)


$s.print_board()
$time = Measure-Command {$s.solve()}
Write-Host ""
Write-Host "Seconds to Solve: $($time.TotalSeconds)"
Write-Host ""
Write-Host "_____________________"
$s.print_board()