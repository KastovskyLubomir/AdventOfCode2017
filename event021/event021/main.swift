//
//  main.swift
//  event021
//
//  Created by Lubomir Kastovsky on 21/12/2017.
//  Copyright © 2017 Avast. All rights reserved.
//

/*
 --- Day 21: Fractal Art ---
 
 You find a program trying to generate some art. It uses a strange process that involves repeatedly enhancing the detail of an image through a set of rules.
 
 The image consists of a two-dimensional square grid of pixels that are either on (#) or off (.). The program always begins with this pattern:
 
 .#.
 ..#
 ###
 Because the pattern is both 3 pixels wide and 3 pixels tall, it is said to have a size of 3.
 
 Then, the program repeats the following process:
 
 If the size is evenly divisible by 2, break the pixels up into 2x2 squares, and convert each 2x2 square into a 3x3 square by following the corresponding enhancement rule.
 Otherwise, the size is evenly divisible by 3; break the pixels up into 3x3 squares, and convert each 3x3 square into a 4x4 square by following the corresponding enhancement rule.
 Because each square of pixels is replaced by a larger one, the image gains pixels and so its size increases.
 
 The artist's book of enhancement rules is nearby (your puzzle input); however, it seems to be missing rules. The artist explains that sometimes, one must rotate or flip the input pattern to find a match. (Never rotate or flip the output pattern, though.) Each pattern is written concisely: rows are listed as single units, ordered top-down, and separated by slashes. For example, the following rules correspond to the adjacent patterns:
 
 ../.#  =  ..
           .#
 
                 .#.
 .#./..#/###  =  ..#
                 ###
 
                         #..#
 #..#/..../#..#/.##.  =  ....
                         #..#
                         .##.
 When searching for a rule to use, rotate and flip the pattern as necessary. For example, all of the following patterns match the same rule:
 
 .#.   .#.   #..   ###
 ..#   #..   #.#   ..#
 ###   ###   ##.   .#.
 Suppose the book contained the following two rules:
 
 ../.# => ##./#../...
 .#./..#/### => #..#/..../..../#..#
 As before, the program begins with this pattern:
 
 .#.
 ..#
 ###
 The size of the grid (3) is not divisible by 2, but it is divisible by 3. It divides evenly into a single square; the square matches the second rule, which produces:
 
 #..#
 ....
 ....
 #..#
 The size of this enhanced grid (4) is evenly divisible by 2, so that rule is used. It divides evenly into four squares:
 
 #.|.#
 ..|..
 --+--
 ..|..
 #.|.#
 Each of these squares matches the same rule (../.# => ##./#../...), three of which require some flipping and rotation to line up with the rule. The output for the rule is the same in all four cases:
 
 ##.|##.
 #..|#..
 ...|...
 ---+---
 ##.|##.
 #..|#..
 ...|...
 Finally, the squares are joined into a new grid:
 
 ##.##.
 #..#..
 ......
 ##.##.
 #..#..
 ......
 Thus, after 2 iterations, the grid contains 12 pixels that are on.
 
 How many pixels stay on after 5 iterations?
 
 Your puzzle answer was 197.
 
 --- Part Two ---
 
 How many pixels stay on after 18 iterations?
 
 Your puzzle answer was 3081737.
 */

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

func rotate(pattern: String) -> String {
	if pattern.count <= 5 {
        var r = String(pattern[pattern.index(pattern.startIndex, offsetBy: 3)])
        r.append(pattern[pattern.startIndex])
        r.append("/")
        r.append(pattern[pattern.index(pattern.startIndex, offsetBy: 4)])
        r.append(pattern[pattern.index(pattern.startIndex, offsetBy: 1)])
        return r
	}
	else {
		var r = String(pattern[pattern.index(pattern.startIndex, offsetBy: 8)])
		r.append(pattern[pattern.index(pattern.startIndex, offsetBy: 4)])
		r.append(pattern[pattern.index(pattern.startIndex, offsetBy: 0)])
        r.append("/")
		r.append(pattern[pattern.index(pattern.startIndex, offsetBy: 9)])
		r.append(pattern[pattern.index(pattern.startIndex, offsetBy: 5)])
		r.append(pattern[pattern.index(pattern.startIndex, offsetBy: 1)])
        r.append("/")
		r.append(pattern[pattern.index(pattern.startIndex, offsetBy: 10)])
		r.append(pattern[pattern.index(pattern.startIndex, offsetBy: 6)])
		r.append(pattern[pattern.index(pattern.startIndex, offsetBy: 2)])
        return r
	}
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

func findPatternFits(rules: Dictionary<String,String>, pattern: String) -> String {
	var pat = pattern
	for i in 0..<4 {
		if rules[pat] != nil {
			return rules[pat]!
		}
        let x = rules[flipVertical(pattern: pat)]
        if x != nil {
            return x!
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
    var x = ""
	if size % 2 == 0 {
		for i in 0..<(size/2) {
			for j in 0..<(size/2) {
                x = String(m[i*2][m[i*2].index(m[i*2].startIndex, offsetBy: j*2)...m[i*2].index(m[i*2].startIndex, offsetBy: (j*2)+1)]) + "/"
				x += String(m[i*2+1][m[i*2+1].index(m[i*2+1].startIndex, offsetBy: j*2)...m[i*2+1].index(m[i*2+1].startIndex, offsetBy: (j*2)+1)])
				arr.append(x)
			}
		}
		return arr
	}
	if size % 3 == 0 {
		for i in 0..<(size/3) {
			for j in 0..<(size/3) {
				x = String(m[i*3][m[i*3].index(m[i*3].startIndex, offsetBy: j*3)...m[i*3].index(m[i*3].startIndex, offsetBy: (j*3)+2)]) + "/"
				x += String(m[i*3+1][m[i*3+1].index(m[i*3+1].startIndex, offsetBy: j*3)...m[i*3+1].index(m[i*3+1].startIndex, offsetBy: (j*3)+2)]) + "/"
				x += String(m[i*3+2][m[i*3+2].index(m[i*3+2].startIndex, offsetBy: j*3)...m[i*3+2].index(m[i*3+2].startIndex, offsetBy: (j*3)+2)])
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
        var line1 = "", line2 = "", line3 = ""
		for i in 0..<sqRoot {
            line1 = ""; line2 = ""; line3 = ""
			for j in 0..<sqRoot {
				let args = patterns[i*sqRoot+j].components(separatedBy: "/")
                line1 += args[0]; line2 += args[1]
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
        var line1 = "", line2 = "", line3 = "", line4 = ""
		for i in 0..<sqRoot {
            line1 = ""; line2 = ""; line3 = ""; line4 = ""
			for j in 0..<sqRoot {
				let args = patterns[i*sqRoot+j].components(separatedBy: "/")
                line1 += args[0]; line2 += args[1]; line3 += args[2]
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

var rules = [String:String]()
for line in inputLines {
    let args = line.components(separatedBy:" => ")
    rules[args[0]] = args[1]
}
let inputPattern = ".#./..#/###"
var inputArr = [inputPattern]

let start = DispatchTime.now() // <<<<<<<<<< Start time
var N = 18

for i in 0..<N {
	print("Iteration: " + String(i))
	let matrixes = replaceWithPatterns(inputPatterns: inputArr, rules: rules)
	let matrix = createMatrix(patterns: matrixes)
    var counts: [Character: Int] = [:]
    matrix.forEach { counts[$0, default: 0] += 1 }
    print(counts)
    if i < N-1 {
        inputArr = getPatterns(matrix: matrix)
    }
	//print("Result: " + inputArr.description)
    print("Matrix size: " + String(matrix.count))
	print("")
}


/*
let transformRules = prepareRules(inputLines: inputLines)
let matchingRules = prepareMatchingRules(inputLines: inputLines)

print(transformRules)
print("")
print(matchingRules)
*/

let end = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
print("Time to evaluate problem : \(timeInterval) seconds")









