//
//  main.swift
//  event014
//
//  Created by Lubomir Kastovsky on 14/12/2017.
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

func arrayUInt8ToArrayInt(array: Array<UInt8>) -> Array<Int> {
	var result = [Int]()
	return result
}

/*
let fileManager = FileManager.default
let fileDir: String = fileManager.currentDirectoryPath
let filePath: String = fileDir.appending("/../input.txt")
let data = fileManager.contents(atPath: filePath)
let str: String = String(data: data!, encoding: String.Encoding.utf8)!

// cut off last character, usualy "\n"
let inStr = str[...str.index(before:str.index(before: str.endIndex))]

var lenArr = stringNumArrayToArrayOfInt(input: String(inStr), separators: [","])

let list = Array(0...255)

let lenArr2 = [3, 4, 1, 5]
let list2 = Array(0...4)
*/

func getNItems(pos: Int, n: Int, fromArray: Array<Int>) -> Array<Int> {
	var result = [Int]()
	if(n>0) {
		if (pos+n-1) < fromArray.count {
			result = Array(fromArray[pos...(pos+n-1)])
		}
		else {
			result = Array(fromArray[pos...]) + Array(fromArray[...((pos+n-1)%fromArray.count)])
		}
	}
	return result
}

func setNItems(pos: Int, n: Int, fromArray: Array<Int>, toArray: Array<Int>) -> Array<Int> {
	var result = toArray
	if(n>0) {
		if (pos == 0) {
			result = fromArray + Array(toArray[(pos+n)...])
			return result
		}
		if (pos+n) < toArray.count {
			result = Array(toArray[0...(pos-1)]) + fromArray + Array(toArray[(pos+n)...])
			return result
		}
		if (pos+n) >= toArray.count {
			result = [Int]()
			result += Array(fromArray[(toArray.count-pos)...])
			if(((pos+n)-toArray.count) <= (pos-1)) {
				result += Array(toArray[((pos+n)-toArray.count)...(pos-1)])
			}
			result += Array(fromArray[0...((toArray.count-pos)-1)])
			return result
		}
	}
	return result
}

func moveCursor(position: Int, move: Int, count: Int) -> Int {
	return ((position+move) % count)
}

func hash(array: Array<Int>, lengths: Array<Int>, pos: Int, skip: Int) -> (result: Array<Int>, skip: Int, pos: Int) {
	var list = array
	var skipSize = skip
	var actualPos = pos
	var l = 0
	for len in lengths {
		l = len
		let reversedArr = Array(getNItems(pos: actualPos, n: l, fromArray: list).reversed())
		list = setNItems(pos: actualPos, n: l, fromArray: reversedArr, toArray: list)
		actualPos = moveCursor(position: actualPos, move: l+skipSize, count: list.count)
		skipSize += 1
	}
	return (list, skipSize, actualPos)
}


//let res1 = hash(array: list2, lengths: lenArr2, pos: 0, skip: 0)
//let result = hash(array: list, lengths: lenArr, pos: 0, skip: 0)

//print(res1)
//print(result)

// second part
func hash64Rounds(array: Array<Int>, lengths: Array<UInt8>, pos: Int, skip: Int) -> Array<Int>{
	var list = array
	var p = pos
	var s = skip
	var lens = [Int]()
	for x in lengths {
		lens.append(Int(x))
	}
	for _ in Array(0...63) {
		let res = hash(array: list, lengths: lens, pos: p, skip: s)
		p = res.pos
		s = res.skip
		list = res.result
	}
	return list
}

func denseHash(array: Array<Int>) -> String {
	var result = [Int]()
	for i in (0...15) {
		let move = i*16
		var xorRes = array[0+move]
		for j in ((1+move)...(15+move)) {
			xorRes ^= array[j]
		}
		result.append(xorRes)
	}
	var dense = ""
	for c in result {
		dense.append(String(format:"%02x", c))
	}
	return dense
}

func denseHashBinary(array: Array<Int>) -> String {
	var result = [Int]()
	for i in (0...15) {
		let move = i*16
		var xorRes = array[0+move]
		for j in ((1+move)...(15+move)) {
			xorRes ^= array[j]
		}
		result.append(xorRes)
	}
	var dense = ""
	for c in result {
		let bin = String(String(c, radix: 2).reversed())
		let padded = String(String(bin.padding(toLength: 8, withPad: "0", startingAt: 0)).reversed())
		//print(padded)
		dense.append(padded)
	}
	return dense
}

/*
let suffix: Array<UInt8> = [17, 31, 73, 47, 23]
var aStr = ""
let buf1 = [UInt8](aStr.utf8)
let lenSeq = buf1 + suffix
print(lenSeq)
let secRes1 = hash64Rounds(array: list, lengths: lenSeq, pos: 0, skip: 0)
let example = "a2582a3a0e66e6e86e3812dcb672a272"
print(denseHash(array: secRes1))
print(example)
print(example.uppercased() == denseHash(array: secRes1).uppercased())

let buf = [UInt8](inStr.utf8)
let lengthSequence = buf + suffix
print(lengthSequence)
let secRes = hash64Rounds(array: list, lengths: lengthSequence, pos: 0, skip: 0)
print(denseHash(array: secRes))

let arrA = [1,2,3,4,5,6,7]
let arrB = [90,91,92,93]
print(setNItems(pos: 5, n: 4, fromArray: arrB, toArray: arrA))
*/

var aStr = "ljoxqyyw-"
//var aStr = "flqrgnkx-"

func getHashes(str: String, num:Int) -> Array<String> {
	let list = Array(0...255)
	let suffix: Array<UInt8> = [17, 31, 73, 47, 23]
	var array = [String]()
	for i in 0..<num {
		var x = str
		x.append(String(i))
		var seq = [UInt8](x.utf8)
		seq += suffix
		let hash = hash64Rounds(array: list, lengths: seq, pos: 0, skip: 0)
		let denHash = denseHash(array: hash)
		//print("In: " + x + " Hash: " + denHash)
		array.append(denHash)
	}
	return array
}


let hashes = getHashes(str: aStr, num: 1)

func numberOfOnes(array: Array<String>) -> Int {
	var count = 0
	for str in array {
		for c in str {
			//print(c)
			if c == "1" || c == "2" || c == "4" || c == "8" {
				count += 1
				continue
			}
			if c == "3" || c == "5" || c == "6" || c == "9" || c == "a" || c == "c" {
				count += 2
				continue
			}
			if c == "f" {
				count += 4
				continue
			}
			if c == "0" {
				continue
			}
			count += 3
 		}
	}
	return count
}

//print(numberOfOnes(array: hashes))

func getHashesBinary(str: String, num:Int) -> Array<String> {
	let list = Array(0...255)
	let suffix: Array<UInt8> = [17, 31, 73, 47, 23]
	var array = [String]()
	for i in 0..<num {
		var x = str
		x.append(String(i))
		var seq = [UInt8](x.utf8)
		seq += suffix
		let hash = hash64Rounds(array: list, lengths: seq, pos: 0, skip: 0)
		let denHash = denseHashBinary(array: hash)
		//print("In: " + x + " Hash: " + denHash)
		array.append(denHash)
	}
	return array
}

let binaryHashes = getHashesBinary(str: aStr, num: 128)
//print(binaryHashes)

var matrix = [[Character]]()
for s in binaryHashes {
	var line = [Character]()
	for c in s {
		line.append(c)
	}
	matrix.append(line)
}

func showMatrix(matrix:Array<Array<Character>>, side: Int) {
	move(0, 0)
	for row in 0..<side {
		for col in 0..<side {
			if matrix[row][col] == "0" {
				mvaddch(Int32(row),Int32(col),UInt32(48))
			}
			if matrix[row][col] == "1" {
				mvaddch(Int32(row),Int32(col),UInt32(49))
			}
			if matrix[row][col] == "X" {
				attron(COLOR_PAIR(1))
				mvaddch(Int32(row),Int32(col),UInt32(88))
				attroff(COLOR_PAIR(1))
			}
		}
	}
	refresh()
	usleep(1000)
}

func markRegion(matrix: Array<Array<Character>>, row: Int, col: Int, side: Int) -> Array<Array<Character>> {
	var newMatrix = matrix
	newMatrix[row][col] = "X"
	showMatrix(matrix: newMatrix, side: 128)
	if row > 0 {
		if newMatrix[row-1][col] == "1" {
			newMatrix = markRegion(matrix: newMatrix, row: row-1, col: col, side: side)
		}
	}
	if row < (side - 1) {
		if newMatrix[row+1][col] == "1" {
			newMatrix = markRegion(matrix: newMatrix, row: row+1, col: col, side: side)
		}
	}
	if col > 0 {
		if newMatrix[row][col-1] == "1" {
			newMatrix = markRegion(matrix: newMatrix, row: row, col: col-1, side: side)
		}
	}
	if col < (side - 1) {
		if newMatrix[row][col+1] == "1" {
			newMatrix = markRegion(matrix: newMatrix, row: row, col: col+1, side: side)
		}
	}
	return newMatrix
}

func countRegions(matrix: Array<Array<Character>>, side: Int) -> Int {
	var newMatrix = matrix
	var regions = 0
	for row in 0..<side {
		for col in 0..<side {
			if newMatrix[row][col] == "1" {
				newMatrix = markRegion(matrix: newMatrix, row: row, col: col, side: side)
				regions += 1
			}
		}
	}
	return regions
}


//print(countRegions(matrix: matrix, side: 128))


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
init_pair(1, Int16(COLOR_RED), Int16(COLOR_BLACK));
let result = countRegions(matrix: matrix, side: 128)
endwin()



