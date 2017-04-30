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
    
    private func nextStepsWithinTheBoard(from c: Position) -> [Position] {
        let moves = nextSteps(from: c).filter { self.isWithin(c: $0) }
        return moves
    }
    
    private struct Move {
        var position: Position
        var availableNextSteps: [Position]
    }
    
    public func getTour(from position: Position) -> [Position] {
        var visited: Set<Position> = [position]
        let nextSteps = nextStepsWithinTheBoard(from: position)
        var path: [Move] = [Move(position: position, availableNextSteps: nextSteps)]
        
        //if path.count == boardSize - awesome we have stepped at each cell once
        while path.count != boardSize && !path.isEmpty {
            let currentMove = path.popLast()! //we know that path is not empty
            let currentPosition = currentMove.position
            var nextSteps = currentMove.availableNextSteps
            
            if nextSteps.isEmpty { // no available next moves
                visited.remove(currentPosition)
                //print("backtracking")
                continue
            }
            
            let nextPosition = nextSteps.popLast()! //we know nextMove is not empty
            
            //have to modify last move's next moves to not repeat
            let modifiedLastMove = Move(position: currentPosition, availableNextSteps: nextSteps)
            path.append(modifiedLastMove)
            
            //making the next move
            visited.insert(nextPosition)
            let availableNextSteps = nextStepsWithinTheBoard(from: nextPosition).filter { !visited.contains($0) }
            let nextMove = Move(position: nextPosition, availableNextSteps: availableNextSteps)
            path.append(nextMove)
        }
        
        return path.map { $0.position }
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
