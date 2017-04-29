

import Foundation

extension String: Error {}

func printUsageAndExit() {
	print("usage: swift knight.swift M N\nwhere M, N - are integer dimensions of the board")
	exit(1)
}

func scanInt(from s: String) -> Int? {
	let scanner = Scanner(string: s)
	var result: Int = 0
	if scanner.scanInt(&result) {
		return result
	}
	return nil
}

public func output(path: [Coordinate], lines M: Int, columns N: Int) {
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


func main() throws {
	if CommandLine.argc < 3 {
		printUsageAndExit()
	}

	guard
		let M = scanInt(from: CommandLine.arguments[1]),
		let N = scanInt(from: CommandLine.arguments[2]) else {
		printUsageAndExit()
		throw "we are done here"
	}

	let board = Board(lines: M, columns: N)
	let path = board.path(from: Coordinate(x: 0, y: 0))
	output(path: path, lines: M, columns: N)
}

try! main()