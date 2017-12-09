//
//  main.swift
//  event004
//
//  Created by Lubomír Kaštovský on 04/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
//

/*

--- Day 4: High-Entropy Passphrases ---

A new system policy has been put in place that requires all accounts to use a passphrase instead of simply a password. A passphrase consists of a series of words (lowercase letters) separated by spaces.

To ensure security, a valid passphrase must contain no duplicate words.

For example:

aa bb cc dd ee is valid.
aa bb cc dd aa is not valid - the word aa appears more than once.
aa bb cc dd aaa is valid - aa and aaa count as different words.
The system's full passphrase list is available as your puzzle input. How many passphrases are valid?

Your puzzle answer was 451.

--- Part Two ---

For added security, yet another system policy has been put in place. Now, a valid passphrase must contain no two words that are anagrams of each other - that is, a passphrase is invalid if any word's letters can be rearranged to form any other word in the passphrase.

For example:

abcde fghij is a valid passphrase.
abcde xyz ecdab is not valid - the letters from the third word can be rearranged to form the first word.
a ab abc abd abf abj is a valid passphrase, because all letters need to be used when forming another word.
iiii oiii ooii oooi oooo is valid.
oiii ioii iioi iiio is not valid - any of these words can be rearranged to form any other word.
Under this new system policy, how many passphrases are valid?

Your puzzle answer was 223.

*/


import Foundation

let input = ""
let fileManager = FileManager.default

let fileDir: String = fileManager.currentDirectoryPath
let filePath: String = fileDir.appending("/../input.file")
let data = fileManager.contents(atPath: filePath)

let str: String = String(data: data!, encoding: String.Encoding.utf8)!

// iterate through lines
let linesArr = str.components(separatedBy: "\n")

var sum2: Int64 = 0
for line in linesArr {
    //print("line: >" + line + "<")
    // find max and min
    
    if !line.isEmpty {
        var lineValid = true
        let wordsArr = line.components(separatedBy: [" ","\n","\t"])
        var firstIndex = 0
        for first in wordsArr {
            var secondIndex = 0
            for second in wordsArr {
                if ((first == second) && (firstIndex != secondIndex)) {
                    //if ((a % b) == 0) {
                    //print("first: " + first + ", second: " + second + ", has same")
                    //    sum2 = sum2 + (a/b)
                    //}
                    
                    //not valid line
                    lineValid = false
                }
                secondIndex += 1
            }
            firstIndex += 1
        }
        //print("\n")
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


print(areAnagrams(first: "abcde", second: "edbca"))

var sum3: Int64 = 0
for line in linesArr {
    //print("line: >" + line + "<")
    // find max and min
    
    if !line.isEmpty {
        var lineValid = true
        let wordsArr = line.components(separatedBy: [" ","\n","\t"])
        var firstIndex = 0
        for first in wordsArr {
            var secondIndex = 0
            for second in wordsArr {
                if (areAnagrams(first: first, second: second) && (firstIndex != secondIndex)) {
                    //print("first: " + first + ", second: " + second + ", has same")
                    //not valid line
                    lineValid = false
                }
                secondIndex += 1
            }
            firstIndex += 1
        }
        //print("\n")
        if lineValid {
            sum3 += 1
        }
    }
}

print(sum3)
