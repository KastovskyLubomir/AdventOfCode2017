//
//  main.swift
//  event011
//
//  Created by Lubomír Kaštovský on 10/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
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

func arrayUInt8ToArrayInt(array: Array<UInt8>) -> Array<Int> {
    var result = [Int]()
    return result
}

let fileManager = FileManager.default
let fileDir: String = fileManager.currentDirectoryPath
let filePath: String = fileDir.appending("/../input.txt")
let data = fileManager.contents(atPath: filePath)
let str: String = String(data: data!, encoding: String.Encoding.utf8)!

// cut off last character, usualy "\n"
let inStr = str.dropLast()
var strArr = inStr.components(separatedBy: [","])
print(strArr.count)

func distanceFromCounts(counts: Dictionary<String, Int>) -> Int {

	var x = 0
	var y = 0
	var z = 0

	if(counts["s"]! > counts["n"]!) {
		x = (counts["s"]! - counts["n"]!)
	}
	else {
		x = (counts["n"]! - counts["s"]!)
	}

	if(counts["ne"]! > counts["sw"]!) {
		y = (counts["ne"]! - counts["sw"]!)
	}
	else {
		y = (counts["sw"]! - counts["ne"]!)
	}

	if(counts["se"]! > counts["nw"]!) {
		z = (counts["se"]! - counts["nw"]!)
	}
	else {
		z = (counts["nw"]! - counts["se"]!)
	}

	if(counts["se"]!+counts["ne"]!) > (counts["sw"]!+counts["nw"]!) {
		if counts["n"]! > counts["s"]! {
			if(x>z) {
				return (y+x)
			}
			return (y+z)
		}
		else {
			if (x > y) {
				return (z+x)
			}
			return (z+y)
		}
	}
	else {
		if counts["n"]! > counts["s"]! {
			if(x>y) {
				return (z+(x-y))
			}
			return (z+(y-x))
		}
		else {
			if (x > z) {
				return (y+(x-z))
			}
			return (y+(z-x))
		}
	}

}

func getMaxDistance(array: Array<String>) -> Int {
	var counts = [String: Int]()
	counts["n"] = 0
	counts["s"] = 0
	counts["se"] = 0
	counts["ne"] = 0
	counts["sw"] = 0
	counts["nw"] = 0
	var max = 0
	for s in array {
		counts[s]! += 1
		let dist = distanceFromCounts(counts: counts)
			if (dist > max) {
				max = dist
			}
	}
	return max
}

print(distanceFromCounts(counts: strArr.reduce(into: [:]) { counts, word in counts[word, default: 0] += 1 }))

let start = DispatchTime.now() // <<<<<<<<<< Start time
print(getMaxDistance(array: strArr))
let end = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
print("Time to evaluate problem : \(timeInterval) seconds")



