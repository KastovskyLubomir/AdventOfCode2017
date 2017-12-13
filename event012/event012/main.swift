//
//  main.swift
//  event012
//
//  Created by Lubomír Kaštovský on 12/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
//

/*
--- Day 12: Digital Plumber ---

Walking along the memory banks of the stream, you find a small village that is experiencing a little confusion: some programs can't communicate with each other.

Programs in this village communicate using a fixed system of pipes. Messages are passed between programs using these pipes, but most programs aren't connected to each other directly. Instead, programs pass messages between each other until the message reaches the intended recipient.

For some reason, though, some of these messages aren't ever reaching their intended recipient, and the programs suspect that some pipes are missing. They would like you to investigate.

You walk through the village and record the ID of each program and the IDs with which it can communicate directly (your puzzle input). Each program has one or more programs with which it can communicate, and these pipes are bidirectional; if 8 says it can communicate with 11, then 11 will say it can communicate with 8.

You need to figure out how many programs are in the group that contains program ID 0.

For example, suppose you go door-to-door like a travelling salesman and record the following list:

0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
In this example, the following programs are in the group that contains program ID 0:

Program 0 by definition.
Program 2, directly connected to program 0.
Program 3 via program 2.
Program 4 via program 2.
Program 5 via programs 6, then 4, then 2.
Program 6 via programs 4, then 2.
Therefore, a total of 6 programs are in this group; all but program 1, which has a pipe that connects it to itself.

How many programs are in the group that contains program ID 0?

Your puzzle answer was 283.

--- Part Two ---

There are more programs than just the ones in the group containing program ID 0. The rest of them have no way of reaching that group, and still might have no way of reaching each other.

A group is a collection of programs that can all communicate via pipes either directly or indirectly. The programs you identified just a moment ago are all part of the same group. Now, they would like you to determine the total number of groups.

In the example above, there were 2 groups: one consisting of programs 0,2,3,4,5,6, and the other consisting solely of program 1.

How many groups are there in total?

Your puzzle answer was 195.
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

func arrayUInt8ToArrayInt(array: Array<UInt8>) -> Array<Int> {
    var result = [Int]()
	for i in array {
		result.append(i.distance(to: UInt8(0)))
	}
    return result
}

let uint8Array : Array<UInt8> = [1,2,3,4,255]
print(arrayUInt8ToArrayInt(array: uint8Array))

let fileManager = FileManager.default
let fileDir: String = fileManager.currentDirectoryPath
let filePath: String = fileDir.appending("/../input.txt")
let data = fileManager.contents(atPath: filePath)
let str: String = String(data: data!, encoding: String.Encoding.utf8)!

let inStrArr = readLinesRemoveEmpty(str: str)

func createDictionary(array: Array<String>) -> Dictionary<Int,[Int]> {
    var dict = [Int: [Int]]()
    for s in array {
        let args = s.components(separatedBy: [" ", ","])
        let key = args[0]
        let value = args[2...]
        var intValue = [Int]()
        for st in value {
            if !st.isEmpty {
                intValue.append(Int(st)!)
            }
        }
        dict[Int(key)!] = intValue
    }
    return dict
}

func groupSize(dict:Dictionary<Int,[Int]>, forKey: Int) -> (size: Int, newDict: Dictionary<Int, [Int]>) {
	var finished = false
	var dict2 = dict

	var intArr = dict2[forKey]!
	dict2.removeValue(forKey: forKey)

	var newArr = [Int]()
	while !finished {
		newArr.removeAll()
		let size = intArr.count
		for i in intArr {
			if(dict2[i] != nil) {
				newArr += dict2[i]!
				dict2[i] = nil
			}
		}
		intArr += newArr
		if (intArr.count == size) {
			finished = true
		}
	}
	return (Set(intArr).count, dict2)
}

func numberOfGroups(dict:Dictionary<Int,[Int]>) -> Int {
	var dict2 = dict
	var groups = 0
	var key = 0
	while dict2.count > 0 {
		let result = groupSize(dict: dict2, forKey: key)
		dict2 = result.newDict
		if !dict2.isEmpty {
			key = dict2.keys[dict2.startIndex]
		}
		groups += 1
	}
	return groups
}


let dict = createDictionary(array: inStrArr)
print(groupSize(dict: dict, forKey: 0).size)
print(numberOfGroups(dict: dict))
