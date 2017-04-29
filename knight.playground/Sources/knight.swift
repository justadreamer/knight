public struct Coordinate: Hashable, Equatable, CustomStringConvertible {
    var x: Int
    var y: Int

    public init (_ pair: (Int, Int)) {
        (x,y) = pair
    }
    
    public init (x: Int, y: Int) {
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
