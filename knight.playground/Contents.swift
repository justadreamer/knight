let M = 4
let N = 3

let board = Board(lines: M, columns: N)

let path = board.getTour(from: Position(x: 0, y: 0))

print("Tour: \(path)")

output(path: path, lines: M, columns: N)
