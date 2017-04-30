public struct Position: Hashable, Equatable, CustomStringConvertible {
    var x: Int
    var y: Int

    public init (_ pair: (Int, Int)) {
        (x,y) = pair
    }
    
    public init (x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    //TODO: better more universal hash?
    public var hashValue: Int {
        return x * 200 + y
    }
    
    public static func ==(lhs: Position, rhs: Position) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    public var description: String {
        get {
            return "(\(x),\(y))"
        }
    }
}

struct TourComputation {
    private struct Move {
        var position: Position
        var availableNextSteps: [Position]
    }

    var board: Board
    var visited: Set<Position> = []
    private var path: [Move] = []
    
    init(start position: Position, board: Board) {
        self.board = board
        visited.insert(position)
        path.append(Move(position: position, availableNextSteps: board.nextStepsWithinTheBoard(from: position)))
    }
    
    func chooseNextStep(outof nextSteps: [Position]) -> Position? {
        if nextSteps.isEmpty {
            return nil
        }
        
        var minCount = 8
        var result = nextSteps.first!
        for position in nextSteps {
            let count = self.board.nextStepsWithinTheBoard(from: position).filter { !visited.contains($0) }.count
            if count < minCount {
                minCount = count
                result = position
            }
        }
        return result
    }

    mutating func compute() -> [Position] {
        //if path.count == boardSize - awesome we have stepped at each cell once
        while path.count != self.board.boardSize && !path.isEmpty {
            let currentMove = path.popLast()! //we know that path is not empty
            let currentPosition = currentMove.position
            let nextSteps = currentMove.availableNextSteps
            
            guard let nextPosition = chooseNextStep(outof: nextSteps) else { // no available next steps
                visited.remove(currentPosition)
                //print("backtracking")
                continue
            }

            remove(nextPosition: nextPosition, from: currentMove)
            makeNextMove(to: nextPosition)
        }
        
        return path.map { $0.position }
    }
    
    private mutating func remove(nextPosition: Position, from currentMove:Move) {
        let modifiedNextSteps = currentMove.availableNextSteps.filter { $0 != nextPosition } //remove chosen from nextSteps
        
        //have to modify last move's next moves to not repeat
        let modifiedLastMove = Move(position: currentMove.position, availableNextSteps: modifiedNextSteps)
        path.append(modifiedLastMove)

    }

    mutating func makeNextMove(to nextPosition: Position) {
        //making the next move
        visited.insert(nextPosition)
        let availableNextSteps = self.board.nextStepsWithinTheBoard(from: nextPosition).filter { !visited.contains($0) }
        let nextMove = Move(position: nextPosition, availableNextSteps: availableNextSteps)
        path.append(nextMove)
    }
}

public class Board {
    var M: Int
    var N: Int
    var boardSize: Int {
        get {
            return M * N
        }
    }
    
    public init(lines m: Int, columns n: Int) {
        M = m
        N = n
    }
    
    private func isWithin(c: Position) -> Bool {
        return c.x >= 0 && c.y >= 0 && c.x < M && c.y < N;
    }
    
    private func nextSteps(from c: Position) -> [Position] {
        /*
         o + o + o
         + o o o +
         o o x o o
         + o o o +
         o + o + o
         */
        let jumps = [(-2,-1),(-1,-2),(-2,1),(-1,2),(1,-2),(2,-1),(1,2),(2,1)]
        let moves = jumps.map { (x,y) -> Position in
            Position((c.x + x, c.y + y)) //Coordinate(x: c.x + x, y: c.y + y)
        }
        return moves
    }
    
    func nextStepsWithinTheBoard(from c: Position) -> [Position] {
        let moves = nextSteps(from: c).filter { self.isWithin(c: $0) }
        return moves
    }
    
    private struct Move {
        var position: Position
        var availableNextSteps: [Position]
    }
    
    public func getTour(from position: Position) -> [Position] {
        var tourComputation = TourComputation(start: position, board: self)
        return tourComputation.compute()
    }
}

import Foundation

public func output(path: [Position], lines M: Int, columns N: Int) {
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
