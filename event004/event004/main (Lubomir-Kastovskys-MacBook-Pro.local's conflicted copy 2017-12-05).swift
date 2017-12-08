//
//  main.swift
//  event004
//
//  Created by Lubomír Kaštovský on 04/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
//

import Foundation

print("Hello, World!")

let input = ""

let fileManager = FileManager.default

let fileDir: String = fileManager.currentDirectoryPath
let filePath: String = fileDir.appending("/input.file")
let data = fileManager.contents(atPath: filePath)

let str: String = String(data: data!, encoding: String.Encoding.utf8)!

// iterate through lines
let linesArr = str.components(separatedBy: "\n")
/*
var sum: Int64 = 0
for line in linesArr {
    print("line: >" + line + "<")
    // find max and min
    if !line.isEmpty {
        var max = Int64.min
        var min = Int64.max
        let numbersArr = line.components(separatedBy: [" ","\n","\t"])
        
        for number in numbersArr {
            //print(">" + number + "<")
            let num = Int64(String(number))!
            if num > max {
                max = num
            }
            if num < min {
                min = num
            }
        }
        print("min: " + String(min))
        print("max: " + String(max))
        sum = sum + (max - min)
    }
}
print("suma: " + String(sum))
*/

var sum2: Int64 = 0
for line in linesArr {
    print("line: >" + line + "<")
    // find max and min
    
    if !line.isEmpty {
        var lineValid = true
        let wordsArr = line.components(separatedBy: [" ","\n","\t"])
        var firstIndex = 0
        for first in wordsArr {
            var secondIndex = 0
            for second in wordsArr {
                //let a: Int64 = Int64(String(divided))!
                //let b: Int64 = Int64(String(divider))!
                if ((first == second) && (firstIndex != secondIndex)) {
                    //if ((a % b) == 0) {
                    print("first: " + first + ", second: " + second + ", has same")
                    //    sum2 = sum2 + (a/b)
                    //}
                    
                    //not valid line
                    lineValid = false
                }
                secondIndex += 1
            }
            firstIndex += 1
        }
        print("\n")
        if lineValid {
            sum2 += 1
        }
    }
}

print(sum2)


func areAnagrams(first: String, second: String) -> Bool{
    
    if(first.count == second.count) {
        var cnt = 0
        for c in first {
            if second.contains(c) {
                cnt += 1
            }
        }
        if(cnt == first.count) {
            return true
        }
    }
    return false;
}


print(areAnagrams(first: "abdex", second: "abdex"))


var sum3: Int64 = 0
for line in linesArr {
    print("line: >" + line + "<")
    // find max and min
    
    if !line.isEmpty {
        var lineValid = true
        let wordsArr = line.components(separatedBy: [" ","\n","\t"])
        var firstIndex = 0
        for first in wordsArr {
            var secondIndex = 0
            for second in wordsArr {
                //let a: Int64 = Int64(String(divided))!
                //let b: Int64 = Int64(String(divider))!
                if (areAnagrams(first: first, second: second) && (firstIndex != secondIndex)) {
                    //if ((a % b) == 0) {
                    print("first: " + first + ", second: " + second + ", has same")
                    //    sum2 = sum2 + (a/b)
                    //}
                    
                    //not valid line
                    lineValid = false
                }
                secondIndex += 1
            }
            firstIndex += 1
        }
        print("\n")
        if lineValid {
            sum3 += 1
        }
    }
}

print(sum3)
