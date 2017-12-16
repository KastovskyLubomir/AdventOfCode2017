//
//  main.swift
//  event016
//
//  Created by Lubomír Kaštovský on 15/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 16: Permutation Promenade ---
 
 You come upon a very unusual sight; a group of programs here appear to be dancing.
 
 There are sixteen programs in total, named a through p. They start by standing in a line: a stands in position 0, b stands in position 1, and so on until p, which stands in position 15.
 
 The programs' dance consists of a sequence of dance moves:
 
 Spin, written sX, makes X programs move from the end to the front, but maintain their order otherwise. (For example, s3 on abcde produces cdeab).
 Exchange, written xA/B, makes the programs at positions A and B swap places.
 Partner, written pA/B, makes the programs named A and B swap places.
 For example, with only five programs standing in a line (abcde), they could do the following dance:
 
 s1, a spin of size 1: eabcd.
 x3/4, swapping the last two programs: eabdc.
 pe/b, swapping programs e and b: baedc.
 After finishing their dance, the programs end up in order baedc.
 
 You watch the dance for a while and record their dance moves (your puzzle input). In what order are the programs standing after their dance?
 
 Your puzzle answer was lgpkniodmjacfbeh.
 
 --- Part Two ---
 
 Now that you're starting to get a feel for the dance moves, you turn your attention to the dance as a whole.
 
 Keeping the positions they ended up in from their previous dance, the programs perform it again and again: including the first dance, a total of one billion (1000000000) times.
 
 In the example above, their second dance would begin with the order baedc, and use the same dance moves:
 
 s1, a spin of size 1: cbaed.
 x3/4, swapping the last two programs: cbade.
 pe/b, swapping programs e and b: ceadb.
 In what order are the programs standing after their billion dances?
 
 Your puzzle answer was hklecbpnjigoafmd.
 */

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
 
// cut off last character, usualy "\n"
let inStr = str[...str.index(before:str.index(before: str.endIndex))]
var dancerProgs = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"]
print("Dancing programs: " + dancerProgs.description)

let inArr = inStr.components(separatedBy: [","])
print("Moves: " + inArr.description)

func dance(moves: Array<String>, input: Array<String>) -> Array<String> {
    var cArr = input
    var x = ""
    var i = 0
    for op in moves {
         if op[op.startIndex] == "s" {
            i = Int(String(op[op.index(after: op.startIndex)..<op.endIndex]))!
            let arr1 = cArr[cArr.index(cArr.endIndex, offsetBy: -i)..<cArr.endIndex]
            let arr2 = cArr[cArr.startIndex..<cArr.index(cArr.endIndex, offsetBy: -i)]
            cArr = Array(arr1 + arr2)
            continue
        }

        if op[op.startIndex] == "x" {
            let positions = String(op[op.index(after:op.startIndex)..<op.endIndex]).components(separatedBy: ["/"])
            let pos1 = Int(positions[0])!
            let pos2 = Int(positions[1])!
            x = cArr[pos1]
            cArr[pos1] = cArr[pos2]
            cArr[pos2] = x
            continue
        }
        
        if op[op.startIndex] == "p" {
            let pos = String(op[op.index(after:op.startIndex)..<op.endIndex]).components(separatedBy: ["/"])
            let first = cArr.index(where: {$0 == pos[0]})!
            let second = cArr.index(where: {$0 == pos[1]})!
            x = cArr[first]
            cArr[first] = cArr[second]
            cArr[second] = x
            continue
        }
    }
    return cArr
}

func createString(input: Array<String>) -> String {
    return input.joined()
}

var firstDance = dance(moves: inArr, input: dancerProgs)
print("After first dance: " + firstDance.joined())

func findRepeatedSequence(generator: (Array<String>, Array<String>) -> Array<String>, _ inArr1: Array<String>, _ inArr2: Array<String>, maxCycles: Int) -> (numberOfAllSteps: Int, distanceBetweenSame: Int, repeatedSeq: Array<String>) {
    
    var steps: Int = 0
    var matrix: Dictionary = [String:Int]()
    var sequence = inArr2
    var index = 0
    var strSeq = ""
    while (steps < maxCycles) {
        steps += 1
        sequence = generator(inArr1, sequence)
        strSeq = sequence.joined()
        if(matrix[strSeq] != nil) {
            let sameIndex = matrix[strSeq]!
            return (steps, index-sameIndex, sequence)
        }
        else {
            matrix[strSeq] = index
        }
        index += 1
    }
    return (0,0,[""])
}

let numberOfCycles = 1000*1000*1000
let result = findRepeatedSequence(generator: dance, inArr, dancerProgs, maxCycles: numberOfCycles)
let cyclesToFindLasSequence = (numberOfCycles - (result.numberOfAllSteps - result.distanceBetweenSame)) % result.distanceBetweenSame
print("Steps to find repeated sequence: " + result.numberOfAllSteps.description)
print("Distance between same sequences: " + result.distanceBetweenSame.description)
print("Cycles to find last sequnce:" + cyclesToFindLasSequence.description)
print("Input for search: " + result.repeatedSeq.joined())
print("Searching ...")
var nextDance = result.repeatedSeq
for _ in 0..<cyclesToFindLasSequence {
    nextDance = dance(moves: inArr, input: nextDance)
}

print("Order after last dance: " + nextDance.joined())
