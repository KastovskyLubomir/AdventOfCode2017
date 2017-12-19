//
//  main.swift
//  event019
//
//  Created by Lubomir Kastovsky on 19/12/2017.
//  Copyright © 2017 Avast. All rights reserved.
//

import Foundation

func readLinesRemoveEmpty(str: String) -> Array<String> {
	var x = str.components(separatedBy: ["\n"])
	for i in x.indices {
		if x[i].isEmpty {
			x.remove(at: i)
		}
	}
	return x
}

// input: "1,2,3,4,5"
func stringNumArrayToArrayOfInt(input:String, separators: CharacterSet) -> Array<Int> {
	var result = [Int]()
	let lenArrStr = input.components(separatedBy: separators)
	for s in lenArrStr {
		if(!s.isEmpty) {
			result.append(Int(s)!)
		}
	}
	return result
}

func getStringBytes(str:String) -> Array<UInt8> {
	let buf1 = [UInt8](str.utf8)
	return buf1
}

let fileManager = FileManager.default
let fileDir: String = fileManager.currentDirectoryPath
let filePath: String = fileDir.appending("/../input.txt")
let data = fileManager.contents(atPath: filePath)
let str: String = String(data: data!, encoding: String.Encoding.utf8)!

let inputLines = readLinesRemoveEmpty(str: str)

var inputMatrix = [[Character]]()
for line in inputLines {
	let lineArgs = Array(line[line.startIndex..<line.endIndex])
	inputMatrix.append(lineArgs)
}
for row in inputMatrix {
	print(row)
}

enum Direction {
	case UP
	case DOWN
	case LEFT
	case RIGHT
	case ERROR
}

func isLetter(ch: Character) -> Bool {
	return (ch >= Character("A")) && (ch <= Character("Z"))
}

func findCoordinatesForUpDown(matrix: Array<Array<Character>>, row: Int, col: Int) -> (row: Int, col: Int, direction: Direction) {
	if col < (matrix[row].count - 1) {
		if (matrix[row][col+1]) != " " {
			return (row: row, col: col+1, Direction.RIGHT)
		}
	}
	if col > 0 {
		if (matrix[row][col-1]) != " " {
			return (row: row, col: col-1, Direction.LEFT)
		}
	}
	return (0,0,Direction.ERROR)
}

func findCoordinatesLeftRight(matrix: Array<Array<Character>>, row: Int, col: Int) -> (row: Int, col: Int, direction: Direction) {
	if row < (matrix.count - 1) {
		if (matrix[row+1][col]) != " " {
			return (row: row+1, col: col, Direction.DOWN)
		}
	}
	if row > 0 {
		if (matrix[row-1][col]) != " " {
			return (row: row-1, col: col, Direction.UP)
		}
	}
	return (0,0,Direction.ERROR)
}

func moveToNext(ch: Character, direction: Direction, matrix: Array<Array<Character>>, row: Int, col: Int) -> (row: Int, col: Int, direction: Direction) {
	if ch == "|"  || isLetter(ch: ch) {
		if (direction == Direction.DOWN) {
			if row < (matrix.count - 1) {
				return (row: row+1, col: col, Direction.DOWN)
			}
		}
		if (direction == Direction.UP) {
			if row > 0 {
				return (row: row-1, col: col, Direction.UP)
			}
		}
		if (direction == Direction.LEFT) {
			return (row: row, col: col-1, Direction.LEFT)
		}
		if (direction == Direction.RIGHT) {
			return (row: row, col: col+1, Direction.RIGHT)
		}
	}
	if ch == "-" || isLetter(ch: ch){
		if direction == Direction.RIGHT {
			if col < (matrix[row].count - 1) {
				return (row: row, col: col+1, Direction.RIGHT)
			}
		}
		if (direction == Direction.LEFT) {
			if col > 0 {
				return (row: row, col: col-1, Direction.LEFT)
			}
		}
		if (direction == Direction.DOWN) {
			return (row: row+1, col: col, Direction.DOWN)
		}
		if (direction == Direction.UP) {
			return (row: row-1, col: col, Direction.UP)
		}
	}
	if ch == "+" {
		if (direction == Direction.DOWN) || (direction == Direction.UP){
			return findCoordinatesForUpDown(matrix: matrix, row: row, col: col)
		}
		if (direction == Direction.LEFT) || (direction == Direction.RIGHT) {
			return findCoordinatesLeftRight(matrix: matrix, row: row, col: col)
		}
	}
	return (0,0,Direction.ERROR)
}

func traverseMatrix(matrix: Array<Array<Character>>) -> (str: String, steps: Int) {
	var result = ""
	var indexRow = 0
	// find start
	var indexCol = matrix[0].index(of:"|")!
	var direction = Direction.DOWN
	var steps = 0

	while true {
		let res = moveToNext(ch: matrix[indexRow][indexCol], direction: direction, matrix: matrix, row: indexRow, col: indexCol)
		indexRow = res.row
		indexCol = res.col
		direction = res.direction
		if (isLetter(ch: matrix[indexRow][indexCol])) {
			result.append(matrix[indexRow][indexCol])
		}
		if direction == Direction.ERROR {
			break;
		}
		steps += 1
	}

	return (result, steps)
}

let result = traverseMatrix(matrix: inputMatrix)
print(result)
