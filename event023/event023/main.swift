//
//  main.swift
//  event023
//
//  Created by Lubomír Kaštovský on 23/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 23: Coprocessor Conflagration ---
 
 You decide to head directly to the CPU and fix the printer from there. As you get close, you find an experimental coprocessor doing so much work that the local programs are afraid it will halt and catch fire. This would cause serious issues for the rest of the computer, so you head in and see what you can do.
 
 The code it's running seems to be a variant of the kind you saw recently on that tablet. The general functionality seems very similar, but some of the instructions are different:
 
 set X Y sets register X to the value of Y.
 sub X Y decreases register X by the value of Y.
 mul X Y sets register X to the result of multiplying the value contained in register X by the value of Y.
 jnz X Y jumps with an offset of the value of Y, but only if the value of X is not zero. (An offset of 2 skips the next instruction, an offset of -1 jumps to the previous instruction, and so on.)
 Only the instructions listed above are used. The eight registers here, named a through h, all start at 0.
 
 The coprocessor is currently set to some kind of debug mode, which allows for testing, but prevents it from doing any meaningful work.
 
 If you run the program (your puzzle input), how many times is the mul instruction invoked?
 
 Your puzzle answer was 3969.
 
 --- Part Two ---
 
 Now, it's time to fix the problem.
 
 The debug mode switch is wired directly to register a. You flip the switch, which makes register a now start at 1 when the program is executed.
 
 Immediately, the coprocessor begins to overheat. Whoever wrote this program obviously didn't choose a very efficient implementation. You'll need to optimize the program if it has any hope of completing before Santa needs that printer working.
 
 The coprocessor's ultimate goal is to determine the final value left in register h once the program completes. Technically, if it had that... it wouldn't even need to run the program.
 
 After setting register a to 1, if the program were to run to completion, what value would be left in register h?
 
 Your puzzle answer was 917.
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

let inputLines = readLinesRemoveEmpty(str: str)

var inputMatrix = [[String]]()

for line in inputLines {
    let lineArgs = line.components(separatedBy: [" "])
    inputMatrix.append(lineArgs)
}

print(inputLines)
print(inputMatrix)

var registers = [String:Int]()

for line in inputMatrix {
    
    if(Int(line[1]) == nil) {
        registers[line[1]] = 0
    }
}

print(registers)

func getRegOrValue(x: String, registers: Dictionary<String, Int>) -> Int {
    if(Int(x) == nil) {
        return registers[x]!
    }
    else {
        return Int(x)!
    }
}

func processInstructions(program: Array<Array<String>>, registers: Dictionary<String, Int>) {
    
    var lineInd = 0
    var regs = registers
    var mul = 0
    
    while (lineInd >= 0) && (lineInd < program.count) {
        if(program[lineInd][0] == "set") {
            let Y = getRegOrValue(x: program[lineInd][2], registers: regs)
            regs[program[lineInd][1]] = Y
        }
        
        if(program[lineInd][0] == "sub") {
            let Y = getRegOrValue(x: program[lineInd][2], registers: regs)
            regs[program[lineInd][1]] = regs[program[lineInd][1]]! - Y
        }
        
        if(program[lineInd][0] == "mul") {
            let Y = getRegOrValue(x: program[lineInd][2], registers: regs)
            regs[program[lineInd][1]] = regs[program[lineInd][1]]! * Y
            mul += 1
        }
        
        if(program[lineInd][0] == "jnz") {
            let X = getRegOrValue(x: program[lineInd][1], registers: regs)
            if X != 0 {
                let Y = getRegOrValue(x: program[lineInd][2], registers: regs)
                lineInd += Y
                continue
            }
        }
        
        lineInd += 1
    }
    print("Mul: " + String(mul))
    print("Registers:" + regs.description)
}

processInstructions(program: inputMatrix, registers: registers)

//---- Part 2

// input code rewritten in swift + neccessary optimalization
// the search for d*e==b must be optimalized otherwise it will do the multiplication square(b-1) times

//var b = 65
//var c = 65
var b = 106500
var c = 123500
var f = 0
var d = 0
var h = 0
var e = 0

var mult = 0

repeat {
    //print(b)
    f = 1
    d = 2
    repeat {
        e = 2
        repeat {
            mult += 1
            if (d*e) == b {
                f = 0
            }
            e = e+1
        } while (e != b) && (f != 0) && ((d*e)<=b)  // added optimalization here +"&& (f != 0) && ((d*e)<=b)"
        d = d + 1
    } while (d != b) && (f != 0)    // added optimalization here +"&& (f != 0)"
    if f == 0 {
        h = h+1
    }
    if b==c { break }
    b += 17
} while true


print("Register h: " + String(h))
print("Multiplication count: " + String(mult))





