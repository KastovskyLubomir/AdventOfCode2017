//
//  main.swift
//  event021
//
//  Created by Lubomir Kastovsky on 21/12/2017.
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

//print(inputLines)

var rules = [String:String]()

for line in inputLines {
	let args = line.components(separatedBy:" => ")
	rules[args[0]] = args[1]
}

//print(rules)

let inputPattern = ".#./..#/###"

func rotate(pattern: String) -> String {
	var rotated = ""
	if pattern.count <= 5 {
		rotated += String(pattern[pattern.index(pattern.startIndex, offsetBy: 3)])
		rotated += String(pattern[pattern.startIndex]) + "/"
		rotated += String(pattern[pattern.index(pattern.startIndex, offsetBy: 4)])
		rotated += String(pattern[pattern.index(pattern.startIndex, offsetBy: 1)])
	}
	else {
		rotated += String(pattern[pattern.index(pattern.startIndex, offsetBy: 8)])
		rotated += String(pattern[pattern.index(pattern.startIndex, offsetBy: 4)])
		rotated += String(pattern[pattern.index(pattern.startIndex, offsetBy: 0)]) + "/"
		rotated += String(pattern[pattern.index(pattern.startIndex, offsetBy: 9)])
		rotated += String(pattern[pattern.index(pattern.startIndex, offsetBy: 5)])
		rotated += String(pattern[pattern.index(pattern.startIndex, offsetBy: 1)]) + "/"
		rotated += String(pattern[pattern.index(pattern.startIndex, offsetBy: 10)])
		rotated += String(pattern[pattern.index(pattern.startIndex, offsetBy: 6)])
		rotated += String(pattern[pattern.index(pattern.startIndex, offsetBy: 2)])
	}
	return rotated
}

func flipVertical(pattern: String) -> String {
	var flipped = ""
	var arr = pattern.components(separatedBy: "/")
	if pattern.count <= 5 {
		flipped = arr[1] + "/" + arr[0]
	}
	else {
		flipped = arr[2] + "/" + arr[1] + "/" + arr[0]
	}
	return flipped
}

func flipHorizontal(pattern: String) -> String {
	var flipped = ""
	var arr: Array<String> = pattern.components(separatedBy: String("/"))
	if pattern.count <= 5 {
		flipped = arr[0].reversed() + String("/")
		flipped += arr[1].reversed()
	}
	else {
		flipped = arr[0].reversed() + "/" + arr[1].reversed() + "/" + arr[2].reversed()
	}
	return flipped
}

func findPatternFits(rules: Dictionary<String,String>, pattern: String) -> String {
	var pat = pattern
	for i in 0..<4 {
		if rules[pat] != nil {
			return rules[pat]!
		}
		if rules[flipVertical(pattern: pat)] != nil {
			return rules[flipVertical(pattern: pat)]!
		}
		if rules[flipHorizontal(pattern: pat)] != nil {
			return rules[flipHorizontal(pattern: pat)]!
		}
		if i <= 2 {
			pat = rotate(pattern: pat)
		}
	}
	return ""
}

func patternSize(pattern: String) -> Int {
	let ind = pattern.index(where: {$0 == "/"})!
	return pattern[pattern.startIndex..<ind].count
}

func getPatterns(matrix: String) -> Array<String> {
	var arr = [String]()
	let size = patternSize(pattern: matrix)
	let m = matrix.components(separatedBy: "/")
	if size % 2 == 0 {
		for i in 0..<(size/2) {
			for j in 0..<(size/2) {
				var a = m[i*2].index(m[i*2].startIndex, offsetBy: j*2)
				var b = m[i*2].index(m[i*2].startIndex, offsetBy: (j*2)+1)
				var x = String(m[i*2][a...b]) + "/"
				a = m[i*2+1].index(m[i*2+1].startIndex, offsetBy: j*2)
				b = m[i*2+1].index(m[i*2+1].startIndex, offsetBy: (j*2)+1)
				x += String(m[i*2+1][a...b])
				arr.append(x)
			}
		}
		return arr
	}
	if size % 3 == 0 {
		for i in 0..<(size/3) {
			for j in 0..<(size/3) {
				var a = m[i*3].index(m[i*3].startIndex, offsetBy: j*3)
				var b = m[i*3].index(m[i*3].startIndex, offsetBy: (j*3)+2)
				var x = String(m[i*3][a...b]) + "/"
				a = m[i*3+1].index(m[i*3+1].startIndex, offsetBy: j*3)
				b = m[i*3+1].index(m[i*3+1].startIndex, offsetBy: (j*3)+2)
				x += String(m[i*3+1][a...b]) + "/"
				a = m[i*3+2].index(m[i*3+2].startIndex, offsetBy: j*3)
				b = m[i*3+2].index(m[i*3+2].startIndex, offsetBy: (j*3)+2)
				x += String(m[i*3+2][a...b])
				arr.append(x)
			}
		}
		return arr
	}
	return arr
}

func createMatrix(patterns: Array<String>) -> String {
	var matrix = ""
	let sqRoot = Int(Double(patterns.count).squareRoot())
	if sqRoot == 1 {
		matrix = patterns[0]
		return matrix
	}
	if sqRoot % 2 == 0 {
		for i in 0..<sqRoot {
			var line1 = ""
			var line2 = ""
			var line3 = ""
			for j in 0..<sqRoot {
				let args = patterns[i*sqRoot+j].components(separatedBy: "/")
				line1 += args[0]
				line2 += args[1]
				if args.count == 3 {
					line3 += args[2]
				}
			}
			matrix += line1 + "/" + line2 + "/"
			if !line3.isEmpty {
				matrix += line3 + "/"
			}
		}
		matrix.removeLast()
		return matrix
	}
	if sqRoot % 3 == 0 {
		for i in 0..<sqRoot {
			var line1 = ""
			var line2 = ""
			var line3 = ""
			var line4 = ""
			for j in 0..<sqRoot {
				let args = patterns[i*sqRoot+j].components(separatedBy: "/")
				line1 += args[0]
				line2 += args[1]
				line3 += args[2]
				if args.count == 4 {
					line4 += args[3]
				}
			}
			matrix += line1 + "/" + line2 + "/" + line3 + "/"
			if !line4.isEmpty {
				matrix += line4 + "/"
			}
		}
		matrix.removeLast()
		return matrix
	}
	return matrix
}

func replaceWithPatterns(inputPatterns: Array<String>, rules: Dictionary<String, String>) -> Array<String> {
	var arr = [String]()
	for p in inputPatterns {
		arr.append(findPatternFits(rules: rules, pattern: p))
	}
	return arr
}

var inputArr = [inputPattern]
//let res = replaceWithPatterns(inputPatterns: inputArr, rules: rules)
//print(res)
//let res2 = getPatterns(matrix: res[0])
//print(res2)
//let res3 = replaceWithPatterns(inputPatterns: res2, rules: rules)
//print(res3)

for i in 0..<5 {
	print("Iteration: " + String(i))
	print("Input: " + inputArr.description)
	let matrixes = replaceWithPatterns(inputPatterns: inputArr, rules: rules)
	print("Patterns: " + matrixes.description)
	let matrix = createMatrix(patterns: matrixes)
	print("Matrix: " + matrix)
	inputArr = getPatterns(matrix: matrix)
	print("Result: " + inputArr.description)
	print("")
}

