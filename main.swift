

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