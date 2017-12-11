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
//let inStr = str[...str.index(before:str.index(before: str.endIndex))]
let inStr = str.dropLast()
var strArr = inStr.components(separatedBy: [","])

func getDistance(array: Array<String>) -> Int {
    
    let counts = array.reduce(into: [:]) { counts, word in counts[word, default: 0] += 1 }
    print(counts)
    let x = (counts["s"]! - counts["n"]!)
    let y = (counts["ne"]! - counts["sw"]!)
    let z = (counts["se"]! - counts["nw"]!)
    print(x)
    print(y)
    print(z)
    return (z+x+(y-x))
}

func biggestDistance(array: Array<String>) -> Int {
    var dict = ["n":0, "s":0, "ne":0, "sw":0, "nw":0, "se":0]
    for s in array {
        
    }
    return 0
}


print(getDistance(array: strArr))









