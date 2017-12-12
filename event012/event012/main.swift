//
//  main.swift
//  event012
//
//  Created by Lubomír Kaštovský on 12/12/2017.
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

let inStrArr = readLinesRemoveEmpty(str: str)

func createDirectory(array: Array<String>) -> Dictionary<Int,[Int]> {
    var dict = [Int: [Int]]()
    for s in array {
        let args = s.components(separatedBy: [" ", ","])
        let key = args[0]
        let value = args[2...]
        print("key: " + key + " value: " + value.description)
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


let dict = createDirectory(array: inStrArr)
print(dict)

var dict2 = dict
var finished = false
var groups = 0
var intArr = [Int]()

while dict2.count > 0 {
    
    for i in Array(0...10000) {
        if( dict2[i] != nil) {
            intArr = dict2[i]!
            dict2.removeValue(forKey: i)
            break;
        }
    }
    var finished = false
    
    while !finished {
        var newArr = [Int]()
        let size = intArr.count
        for i in intArr {
            if(dict2[i] != nil) {
                newArr += dict2[i]!
                dict2[i] = nil
            }
        }
        print(intArr)
        print(newArr)
        intArr += newArr
        print(intArr.description + "\n")
        if (intArr.count == size) {
            finished = true
        }
    }
    print(intArr.count)
    print(Set(intArr).count)
    groups += 1
}

print(groups)
