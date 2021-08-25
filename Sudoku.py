from timeit import default_timer as timer

board = [
    [0,0,0, 0,3,0, 0,0,0],
    [0,0,1, 0,7,6, 9,4,0],
    [0,8,0, 9,0,0, 0,0,0],

    [0,4,0, 0,0,1, 0,0,0],
    [0,2,8, 0,9,0, 0,0,0],
    [0,0,0, 0,0,0, 1,6,0],

    [7,0,0, 8,0,0, 0,0,0],
    [0,0,0, 0,0,0, 4,0,2],
    [0,9,0, 0,1,0, 3,0,0]
]

def print_board():
    global board
    for i in range(9):
        if i % 3 == 0 and i != 0:
            print ("- - - - - - - - - - -")

        for j in range(9):
            if j % 3 == 0 and j != 0:
                print("| ", end='')

            if j == 8:
                print (board[i][j])

            else:
                print (str(board[i][j]) + " ", end='')

def find_empty():
    global board
    for i in range(9):
        for j in range(9):
            if board[i][j] == 0:
                return (i, j)  # row, col

    return None


def valid(num, pos):
    global board
    # Check row
    for i in range(9):
        if board[pos[0]][i] == num and pos[1] != i:
            return False

    # Check column
    for i in range(9):
        if board[i][pos[1]] == num and pos[0] != i:
            return False

    # Check box
    box_x = pos[1] // 3
    box_y = pos[0] // 3

    for i in range(box_y*3, box_y*3 + 3):
        for j in range(box_x*3, box_x*3 + 3):
            if board[i][j] == num and (i,j) != pos:
                return False

    return True

def solve():
    global board
    find = find_empty()
    if not find:
        return True

    else:
        row, col = find
        #print ("\rSolving... Row: %d, Col: %d" % (row+1,col+1), end='')

    for i in range(1, 10):
        if valid(i, (row, col)):
            board[row][col] = i

            if solve():
                return True

            board[row][col] = 0

    return False


print_board()

start = timer()
solve()
print("")
print("Seconds to Solve: ", timer() - start)

print ("")
print ("_____________________")
print_board()