//
//  main.swift
//  event008
//
//  Created by Lubomír Kaštovský on 08/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 8: I Heard You Like Registers ---
 
 You receive a signal directly from the CPU. Because of your recent assistance with jump instructions, it would like you to compute the result of a series of unusual register instructions.
 
 Each instruction consists of several parts: the register to modify, whether to increase or decrease that register's value, the amount by which to increase or decrease it, and a condition. If the condition fails, skip the instruction without modifying the register. The registers all start at 0. The instructions look like this:
 
 b inc 5 if a > 1
 a inc 1 if b < 5
 c dec -10 if a >= 1
 c inc -20 if c == 10
 These instructions would be processed as follows:
 
 Because a starts at 0, it is not greater than 1, and so b is not modified.
 a is increased by 1 (to 1) because b is less than 5 (it is 0).
 c is decreased by -10 (to 10) because a is now greater than or equal to 1 (it is 1).
 c is increased by -20 (to -10) because c is equal to 10.
 After this process, the largest value in any register is 1.
 
 You might also encounter <= (less than or equal to) or != (not equal to). However, the CPU doesn't have the bandwidth to tell you what all the registers are named, and leaves that to you to determine.
 
 What is the largest value in any register after completing the instructions in your puzzle input?
 
 Your puzzle answer was 6828.
 
 --- Part Two ---
 
 To be safe, the CPU also needs to know the highest value held in any register during this process so that it can decide how much memory to allocate to these operations. For example, in the above instructions, the highest value ever held was 10 (in register c after the third instruction was evaluated).
 
 Your puzzle answer was 7234.
 */

import Foundation

let fileManager = FileManager.default

let fileDir: String = fileManager.currentDirectoryPath
let filePath: String = fileDir.appending("/../../input.txt")
let data = fileManager.contents(atPath: filePath)

let str: String = String(data: data!, encoding: String.Encoding.utf8)!

// iterate through lines
let linesArr = str.components(separatedBy: "\n")

var registers : Dictionary = [String : Int] ()

for line in linesArr {
    if !line.isEmpty {
        let lineArgs = line.components(separatedBy: " ")
        print(lineArgs)
        registers[lineArgs[0]] = 0
    }
}

func operationOnReg(reg: String, op: String, value: Int) {
    if op == "inc" {
        registers[reg] = registers[reg]! + value
    }
    if op == "dec" {
        registers[reg] = registers[reg]! - value
    }
}

var absoluteMax = Int.min
for line in linesArr {
    if !line.isEmpty {
        let lineArgs = line.components(separatedBy: " ")
        let regName = lineArgs[0];
        let condRegName = lineArgs[4]
        let operation = lineArgs[5]
        if (operation == "<") {
            if registers[condRegName]! < Int(lineArgs[6])! {
                operationOnReg(reg:regName , op: lineArgs[1], value: Int(lineArgs[2])!)
            }
        }
        if (operation == ">") {
            if registers[condRegName]! > Int(lineArgs[6])! {
                operationOnReg(reg:regName , op: lineArgs[1], value: Int(lineArgs[2])!)
            }
        }
        if (operation == "<=") {
            if registers[condRegName]! <= Int(lineArgs[6])! {
                operationOnReg(reg:regName , op: lineArgs[1], value: Int(lineArgs[2])!)
            }
        }
        if (operation == ">=") {
            if registers[condRegName]! >= Int(lineArgs[6])! {
                operationOnReg(reg:regName , op: lineArgs[1], value: Int(lineArgs[2])!)
            }
        }
        if (operation == "==") {
            if registers[condRegName]! == Int(lineArgs[6])! {
                operationOnReg(reg:regName , op: lineArgs[1], value: Int(lineArgs[2])!)
            }
        }
        if (operation == "!=") {
            if registers[condRegName]! != Int(lineArgs[6])! {
                operationOnReg(reg:regName , op: lineArgs[1], value: Int(lineArgs[2])!)
            }
        }
        
        for key in registers.keys {
            if( registers[key]! > absoluteMax ) {
                absoluteMax = registers[key]!
            }
        }
        
    }
}

var max = Int.min
for key in registers.keys {
    if( registers[key]! > max ) {
        max = registers[key]!
    }
}

print(registers)
print("Maximum: " + String(max))
print("Absolute maximum: " + String(absoluteMax))

