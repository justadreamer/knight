import Foundation

//board size, can be rectangular
extension String: Error {
    
}
func printUsageAndExit() {
    print("usage: swift knight.swift M N\nwhere M, N - are integer dimensions of the board")
    exit(1)
}

if CommandLine.argc < 3 {
    printUsageAndExit()
}

func scanInt(from s: String) -> Int? {
    let scanner = Scanner(string: s)
    var result: Int = 0
    if scanner.scanInt(&result) {
        return result
    }
    return nil
}

guard let M = scanInt(from: CommandLine.arguments[1]), let N = scanInt(from: CommandLine.arguments[2]) else {
    printUsageAndExit()
    throw "we are done here"
}

/*
func drawBoard(m: Int, n: Int) -> UIView {
    let d = 100
    let frame = CGRect(x: 0, y: 0, width: d*N, height: d*M)
    let view = UIView(frame: frame)
    for i in 0..<m {
        for j in 0..<n {
            let cell = UIView(frame: CGRect(x: i*d, y: j*d, width: d, height: d))
            cell.backgroundColor = (i + j) % 2 == 0 ? .white : .black
            view.addSubview(cell)
        }
    }
    return view
}

let view = drawBoard(m: M, n: N)
PlaygroundPage.current.liveView = view
*/

struct Coordinate: Hashable, Equatable, CustomStringConvertible {
    var x: Int
    var y: Int

    public var hashValue: Int {
        return x * 200 + y
    }
    
    public static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    public var description: String {
        get {
            return "(\(x),\(y))"
        }
    }
}

class Board {
    var M: Int
    var N: Int
    var boardSize: Int {
        get {
            return M * N
        }
    }
    
    init(m: Int, n: Int) {
        M = m
        N = n
    }
    
    private func isWithin(c: Coordinate) -> Bool {
        return c.x >= 0 && c.y >= 0 && c.x < M && c.y < N;
    }

    private func nextMovesWithinTheBoard(c: Coordinate) -> [Coordinate] {
/*
o + o + o
+ o o o +
o o x o o
+ o o o +
o + o + o
*/
        let jumps = [(-2,-1),(-1,-2),(-2,1),(-1,2),(1,-2),(2,-1),(1,2),(2,1)]
        let moves = jumps.map { (x,y) -> Coordinate in
            Coordinate(x: c.x + x, y: c.y + y)
        }.filter { self.isWithin(c: $0) }
        return moves
    }
    
    private struct Move {
        var coordinate: Coordinate
        var availableNextMoves: [Coordinate]
    }
    
    public func path(from c: Coordinate) -> [Coordinate] {
        var visited: Set<Coordinate> = [c]
        let nextMoves = nextMovesWithinTheBoard(c: c)
        var path: [Move] = [Move(coordinate:c, availableNextMoves:nextMoves)]

        //if path.count == boardSize - awesome we have stepped at each cell once
        while path.count != boardSize && !path.isEmpty {
            let lastMove = path.last! //we know that path is not empty
            
            var nextMoves = lastMove.availableNextMoves
            if nextMoves.isEmpty { // no available next moves
                _ = path.popLast()
                visited.remove(lastMove.coordinate)
                //print("backtracking")
                continue
            }
            
            let nextCoordinate = nextMoves.popLast()! //we know nextMove is not empty
            
            //have to modify last move's next moves to not repeat
            path[path.count - 1] = Move(coordinate: lastMove.coordinate, availableNextMoves: nextMoves)
            visited.insert(nextCoordinate)
            let availableNextMoves = nextMovesWithinTheBoard(c: nextCoordinate).filter { !visited.contains($0) }
            path.append(Move(coordinate: nextCoordinate, availableNextMoves: availableNextMoves))
        }

        return path.map { $0.coordinate }
    }
}

func output(path: [Coordinate]) {
    guard path.count > 0 else { 
        print("No path")
        return
    }

    var D: [[Int]] = Array(repeating:Array(repeating:0, count:N), count: M)
    for (i, c) in path.enumerated() {
        D[c.x][c.y] = i+1
    }

    for i in 0..<D.count {
        let s = D[i].map { String(format: "%2d", $0) }.joined(separator: " ")
        print("\(s)")
    }
}

let board = Board(m:M, n:N)
let path = board.path(from: Coordinate(x: 0, y: 0))
output(path: path)