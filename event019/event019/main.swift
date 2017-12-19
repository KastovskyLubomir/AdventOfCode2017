//
//  main.swift
//  event019
//
//  Created by Lubomir Kastovsky on 19/12/2017.
//  Copyright © 2017 Avast. All rights reserved.
//

import Foundation
import Darwin.ncurses

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

/*
for row in inputMatrix {
	print(row)
}
*/

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
	if ch == "|"  || isLetter(ch: ch) || ch == "@" {
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
	if ch == "-" || isLetter(ch: ch) || ch == "@" {
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

func showMatrixPart(matrix:Array<Array<Character>>, row: Int, col: Int, sideRow: Int, sideCol: Int) {
	move(0, 0)
	var r = 0
	var c = 0
	var maxR = matrix.count - 1
	var maxC = matrix[0].count - 1

	if (row - (sideRow/2)) < 0 {
		maxR = sideRow
	}
	else {
		if (row + (sideRow/2)) >= maxR {
			r = maxR - sideRow
		}
		else {
			r = (row - (sideRow/2))
			maxR = (row + (sideRow/2))
		}
	}

	if (col - (sideCol/2)) < 0 {
		maxC = sideCol
	}
	else {
		if (col + (sideCol/2)) >= maxC {
			c = maxC - sideCol
		}
		else {
			c = (col - (sideCol/2))
			maxC = (col + (sideCol/2))
		}
	}

	for y in r..<maxR {
		for x in c..<maxC {
			if (x==col) && (y==row) {
				attron(COLOR_PAIR(1))
				let ch: UInt32 = UInt32(Array(String(matrix[y][x]).utf8)[0])
				mvaddch(Int32(y-r),Int32(x-c),UInt32(ch))
				attroff(COLOR_PAIR(1))
			}
			else {
				if isLetter(ch: matrix[y][x]) {
					attron(COLOR_PAIR(2))
					let ch: UInt32 = UInt32(Array(String(matrix[y][x]).utf8)[0])
					mvaddch(Int32(y-r),Int32(x-c),UInt32(ch))
					attroff(COLOR_PAIR(2))
				}
				else {
					let ch: UInt32 = UInt32(Array(String(matrix[y][x]).utf8)[0])
					mvaddch(Int32(y-r),Int32(x-c),UInt32(ch))
				}
			}
		}
	}
}

func showStatus(foundCharacters: String, steps: Int, line: Int32) {
	move(line,0)
	let str = "Collected letters: " + foundCharacters
	addstr(str)
	move(line+1,0)
	let str2 = "Steps: " + String(steps)
	addstr(str2)

}

func traverseMatrix(inputMatrix: Array<Array<Character>>, animate: Bool) -> (str: String, steps: Int) {
	var matrix = inputMatrix
	var result = ""
	var indexRow = 0
	// find start
	var indexCol = matrix[0].index(of:"|")!
	var direction = Direction.DOWN
	var steps = 0

	while true {
		if animate {
			showMatrixPart(matrix: matrix, row: indexRow, col: indexCol, sideRow: 50, sideCol: 100)
			showStatus(foundCharacters: result, steps: steps, line: 51)
			refresh()
			usleep(5000)
			if isLetter(ch: matrix[indexRow][indexCol]) {
				sleep(3)
			}
		}
		let res = moveToNext(ch: matrix[indexRow][indexCol], direction: direction, matrix: matrix, row: indexRow, col: indexCol)
		matrix[indexRow][indexCol] = "@"
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


initscr()                   // Init window. Must be first
cbreak()
noecho()                    // Don't echo user input
nonl()                      // Disable newline mode
intrflush(stdscr, true)     // Prevent flush
keypad(stdscr, true)        // Enable function and arrow keys
curs_set(1)                 // Set cursor to invisible
move(0, 0)
refresh()
start_color()
init_pair(1, Int16(COLOR_BLUE), Int16(COLOR_YELLOW));
init_pair(2, Int16(COLOR_RED), Int16(COLOR_WHITE));
let result = traverseMatrix(inputMatrix: inputMatrix, animate: true)
endwin()
print(result)

