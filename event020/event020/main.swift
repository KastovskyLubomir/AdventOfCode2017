//
//  main.swift
//  event020
//
//  Created by Lubomír Kaštovský on 19/12/2017.
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

let fileManager = FileManager.default
let fileDir: String = fileManager.currentDirectoryPath
let filePath: String = fileDir.appending("/../input.txt")
let data = fileManager.contents(atPath: filePath)
let str: String = String(data: data!, encoding: String.Encoding.utf8)!

let inputLines = readLinesRemoveEmpty(str: str)

struct Particle: Equatable {
	var p: Array<Int64>
	var v: Array<Int64>
	var a: Array<Int64>
	var dist: Int64
	var str: String
	static func == (p1: Particle, p2: Particle) -> Bool {
		return p1.str == p2.str
	}
}

func particleToString(p: Particle) ->String {
	return String(p.p[0]) + "," + String(p.p[1]) + "," + String(p.p[0])
}

func parseInput(lines:Array<String>) -> Array<Particle> {
	var vectorData = [Particle]()
	for line in lines {
		let lineArgs = line.components(separatedBy: ["=", " ", ",", "<", ">"])
		var particle = Particle(p:[],v:[],a:[],dist:0,str:"")
		particle.p = [Int64(lineArgs[2])!, Int64(lineArgs[3])!, Int64(lineArgs[4])!]
		particle.v = [Int64(lineArgs[9])!, Int64(lineArgs[10])!, Int64(lineArgs[11])!]
		particle.a = [Int64(lineArgs[16])!, Int64(lineArgs[17])!, Int64(lineArgs[18])!]
		particle.dist = abs(particle.p[0]) + abs(particle.p[1]) + abs(particle.p[2])
		particle.str = particleToString(p: particle)
		vectorData.append(particle)
	}
	return vectorData
}

func particleUpdate(p: Particle) -> Particle {
	var newP = p
	newP.v = [newP.v[0]+newP.a[0], newP.v[1]+newP.a[1], newP.v[2]+newP.a[2]]
	newP.p = [newP.p[0]+newP.v[0], newP.p[1]+newP.v[1], newP.p[2]+newP.v[2]]
	newP.dist = abs(newP.p[0]) + abs(newP.p[1]) + abs(newP.p[2])
	newP.str = particleToString(p: newP)
	return newP
}

/*--- Part 1 */

var vectorData = parseInput(lines: inputLines)
var tick = 0

/*
var smallestDistanceIndex = 0
var smallestDistance = Int64.max
while tick < 10000 {
	smallestDistance = Int64.max
	for i in 0..<vectorData.count {
		if vectorData[i].dist < smallestDistance {
			smallestDistanceIndex = i
			smallestDistance = vectorData[i].dist
		}
	}
	for i in 0..<vectorData.count {
		vectorData[i] = particleUpdate(p: vectorData[i])
	}
	tick += 1
}

print("Smallest distance:" + String(smallestDistance))
print("Smallest distance index:" + String(smallestDistanceIndex))
*/

/*--- Part 2 */

func removeParticle(p: Particle, vectorData: Array<Particle>) -> Array<Particle> {
	var data = vectorData
	var i = 0
	while i < data.count {
		if(p.str == data[i].str) {
			data.remove(at: i)
		}
		else {
			i += 1
		}
	}
	return data
}

func removeColidingParticles(input: Array<Particle>) -> Array<Particle> {
	var vectorData = [Particle]()
	/*
	var i = 0
	var j = 0
	while i < vectorData.count {
		j = 0
		while j < vectorData.count {
			if i != j {
				if vectorData[i][0] == vectorData[j][0] {
					vectorData = removeParticle(p: vectorData[i][0], vectorData: vectorData)
					i = 0
					break
				}
			}
			j += 1
		}
		i += 1
	}*/

	var counts: [String: Int] = [:]
	input.forEach { counts[$0.str, default: 0] += 1 }
	var debug = [String:Int]()
	for x in input {
		if counts[x.str] == 1 {
			vectorData.append(x)
		}
		else {
			debug[x.str] = counts[x.str]
		}
	}
	print(debug)
	return vectorData
}

vectorData = parseInput(lines: inputLines)
tick = 0
while tick < 10000 {
	vectorData = removeColidingParticles(input: vectorData)
	for i in 0..<vectorData.count {
		vectorData[i] = particleUpdate(p: vectorData[i])
	}
	print(vectorData.count)
	if vectorData.count == 437 {
		break
	}
	tick += 1
}

print("Particles remaining:" + String(vectorData.count))
