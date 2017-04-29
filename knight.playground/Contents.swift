//: Playground - noun: a place where people can play

//import UIKit
import PlaygroundSupport

//board size, can be rectangular
let M = 4 //m lines
let N = 3 //n columns

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

    init (_ pair: (Int, Int)) {
        (x,y) = pair
/*        x = pair.0
        y = pair.1*/
    }

    init (x: Int, y: Int) {
        self.x = x
        self.y = y
    }

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

    private func nextMoves(from c: Coordinate) -> [Coordinate] {
        /*
         o + o + o
         + o o o +
         o o x o o
         + o o o +
         o + o + o
         */
        let jumps = [(-2,-1),(-1,-2),(-2,1),(-1,2),(1,-2),(2,-1),(1,2),(2,1)]
        let moves = jumps.map { (x,y) -> Coordinate in
            Coordinate((c.x + x, c.y + y)) //Coordinate(x: c.x + x, y: c.y + y)
        }
        return moves
    }

    private func nextMovesWithinTheBoard(from c: Coordinate) -> [Coordinate] {
        let moves = nextMoves(from: c).filter { self.isWithin(c: $0) }
        return moves
    }
    
    private struct Move {
        var coordinate: Coordinate
        var availableNextMoves: [Coordinate]
    }
    
    public func path(from c: Coordinate) -> [Coordinate] {
        var visited: Set<Coordinate> = [c]
        let nextMoves = nextMovesWithinTheBoard(from: c)
        var path: [Move] = [Move(coordinate:c, availableNextMoves:nextMoves)]

        //if path.count == boardSize - awesome we have stepped at each cell once
        while path.count != boardSize && !path.isEmpty {
            let currentMove = path.popLast()! //we know that path is not empty
            let currentCoordinate = currentMove.coordinate
            var nextMoves = currentMove.availableNextMoves

            if nextMoves.isEmpty { // no available next moves
                visited.remove(currentCoordinate)
                //print("backtracking")
                continue
            }
            
            let nextCoordinate = nextMoves.popLast()! //we know nextMove is not empty
            
            //have to modify last move's next moves to not repeat
            let modifiedLastMove = Move(coordinate: currentCoordinate, availableNextMoves: nextMoves)
            path.append(modifiedLastMove)

            //making the next move
            visited.insert(nextCoordinate)
            let availableNextMoves = nextMovesWithinTheBoard(from: nextCoordinate).filter { !visited.contains($0) }
            let nextMove = Move(coordinate: nextCoordinate, availableNextMoves: availableNextMoves)
            path.append(nextMove)
        }

        return path.map { $0.coordinate }
    }
}

let board = Board(m:M, n:N)
let path = board.path(from: Coordinate(x: 0, y: 0))
print("Path: \(path)")