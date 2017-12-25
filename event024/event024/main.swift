//
//  main.swift
//  event024
//
//  Created by Lubomír Kaštovský on 23/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 24: Electromagnetic Moat ---
 
 The CPU itself is a large, black building surrounded by a bottomless pit. Enormous metal tubes extend outward from the side of the building at regular intervals and descend down into the void. There's no way to cross, but you need to get inside.
 
 No way, of course, other than building a bridge out of the magnetic components strewn about nearby.
 
 Each component has two ports, one on each end. The ports come in all different types, and only matching types can be connected. You take an inventory of the components by their port types (your puzzle input). Each port is identified by the number of pins it uses; more pins mean a stronger connection for your bridge. A 3/7 component, for example, has a type-3 port on one side, and a type-7 port on the other.
 
 Your side of the pit is metallic; a perfect surface to connect a magnetic, zero-pin port. Because of this, the first port you use must be of type 0. It doesn't matter what type of port you end with; your goal is just to make the bridge as strong as possible.
 
 The strength of a bridge is the sum of the port types in each component. For example, if your bridge is made of components 0/3, 3/7, and 7/4, your bridge has a strength of 0+3 + 3+7 + 7+4 = 24.
 
 For example, suppose you had the following components:
 
 0/2
 2/2
 2/3
 3/4
 3/5
 0/1
 10/1
 9/10
 With them, you could make the following valid bridges:
 
 0/1
 0/1--10/1
 0/1--10/1--9/10
 0/2
 0/2--2/3
 0/2--2/3--3/4
 0/2--2/3--3/5
 0/2--2/2
 0/2--2/2--2/3
 0/2--2/2--2/3--3/4
 0/2--2/2--2/3--3/5
 (Note how, as shown by 10/1, order of ports within a component doesn't matter. However, you may only use each port on a component once.)
 
 Of these bridges, the strongest one is 0/1--10/1--9/10; it has a strength of 0+1 + 1+10 + 10+9 = 31.
 
 What is the strength of the strongest bridge you can make with the components you have available?
 
 Your puzzle answer was 1695.
 
 --- Part Two ---
 
 The bridge you've built isn't long enough; you can't jump the rest of the way.
 
 In the example above, there are two longest bridges:
 
 0/2--2/2--2/3--3/4
 0/2--2/2--2/3--3/5
 Of them, the one which uses the 3/5 component is stronger; its strength is 0+2 + 2+2 + 2+3 + 3+5 = 19.
 
 What is the strength of the longest bridge you can make? If you can make multiple bridges of the longest length, pick the strongest one.
 
 Your puzzle answer was 1673.
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
print(inputLines)

func parseInput(lines: Array<String>) -> Array<(Int, Int)> {
    var result = [(Int, Int)]()
    for line in lines {
        let args = line.components(separatedBy: "/")
        result.append((Int(args[0])!, Int(args[1])!))
    }
    return result
}

var ports = parseInput(lines: inputLines)
print(ports)

func findPossibleNeighbours(pin: Int, ports: Array<(Int, Int)>) -> Array<Int> {
    var indexes = [Int]()
    for i in 0..<ports.count {
        if ports[i].0 == pin || ports[i].1 == pin {
            indexes += [i]
        }
    }
    return indexes
}

func createConnections(startPin: Int, ports: Array<(Int, Int)>) -> Array<Array<(Int, Int)>> {
    var resultPorts = [[(Int,Int)]]()
    var g = [(Int, Int)]()
    let neighGroup = findPossibleNeighbours(pin: startPin, ports: ports)
    for i in neighGroup {
        g = ports
        g.remove(at: i)
        if startPin == ports[i].0 {
            let connections1 = createConnections(startPin: ports[i].1, ports: g)
            for c in connections1 {
                resultPorts.append([ports[i]]+c)
            }
        }
        else {
            let connections0 = createConnections(startPin: ports[i].0, ports: g)
            for c in connections0 {
                resultPorts.append([ports[i]]+c)
            }
        }
        resultPorts.append([ports[i]])
    }
    return resultPorts
}

func strength(ports: Array<(Int, Int)>) -> Int {
    var strength = 0
    for p in ports {
        strength += p.0 + p.1
    }
    return strength
}

print("\n")

var maxStrength = 0
var maxLength = 0
var strengthOfLongest = 0
var longestBridge = [(Int, Int)]()
var strongestBridge = [(Int, Int)]()

let start = DispatchTime.now() // <<<<<<<<<< Start time

let connections = createConnections(startPin: 0, ports: ports)
for c in connections {
    let stren = strength(ports: c)
    if stren > maxStrength {
        maxStrength = stren
        strongestBridge = c
    }
    if c.count >= maxLength {
        if stren > strengthOfLongest {
            strengthOfLongest = stren
            longestBridge = c
        }
        maxLength = c.count
    }
    
}

print("Strongest bridge: " + strongestBridge.description)
print("Maximal strength: " + String(maxStrength))
print("")
print("Longest bridge length: " + String(longestBridge.count) + " Bridge: " + longestBridge.description)
print("Stength of longest: " + String(strengthOfLongest))

let end = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
print("\nTime to evaluate problem : \(timeInterval) seconds")

