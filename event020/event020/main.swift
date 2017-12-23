//
//  main.swift
//  event020
//
//  Created by Lubomír Kaštovský on 19/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
//

/*
 --- Day 20: Particle Swarm ---
 
 Suddenly, the GPU contacts you, asking for help. Someone has asked it to simulate too many particles, and it won't be able to finish them all in time to render the next frame at this rate.
 
 It transmits to you a buffer (your puzzle input) listing each particle in order (starting with particle 0, then particle 1, particle 2, and so on). For each particle, it provides the X, Y, and Z coordinates for the particle's position (p), velocity (v), and acceleration (a), each in the format <X,Y,Z>.
 
 Each tick, all particles are updated simultaneously. A particle's properties are updated in the following order:
 
 Increase the X velocity by the X acceleration.
 Increase the Y velocity by the Y acceleration.
 Increase the Z velocity by the Z acceleration.
 Increase the X position by the X velocity.
 Increase the Y position by the Y velocity.
 Increase the Z position by the Z velocity.
 Because of seemingly tenuous rationale involving z-buffering, the GPU would like to know which particle will stay closest to position <0,0,0> in the long term. Measure this using the Manhattan distance, which in this situation is simply the sum of the absolute values of a particle's X, Y, and Z position.
 
 For example, suppose you are only given two particles, both of which stay entirely on the X-axis (for simplicity). Drawing the current states of particles 0 and 1 (in that order) with an adjacent a number line and diagram of current X positions (marked in parenthesis), the following would take place:
 
 p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>    -4 -3 -2 -1  0  1  2  3  4
 p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>                         (0)(1)
 
 p=< 4,0,0>, v=< 1,0,0>, a=<-1,0,0>    -4 -3 -2 -1  0  1  2  3  4
 p=< 2,0,0>, v=<-2,0,0>, a=<-2,0,0>                      (1)   (0)
 
 p=< 4,0,0>, v=< 0,0,0>, a=<-1,0,0>    -4 -3 -2 -1  0  1  2  3  4
 p=<-2,0,0>, v=<-4,0,0>, a=<-2,0,0>          (1)               (0)
 
 p=< 3,0,0>, v=<-1,0,0>, a=<-1,0,0>    -4 -3 -2 -1  0  1  2  3  4
 p=<-8,0,0>, v=<-6,0,0>, a=<-2,0,0>                         (0)
 At this point, particle 1 will never be closer to <0,0,0> than particle 0, and so, in the long run, particle 0 will stay closest.
 
 Which particle will stay closest to position <0,0,0> in the long term?
 
 Your puzzle answer was 161.
 
 --- Part Two ---
 
 To simplify the problem further, the GPU would like to remove any particles that collide. Particles collide if their positions ever exactly match. Because particles are updated simultaneously, more than two particles can collide at the same time and place. Once particles collide, they are removed and cannot collide with anything else after that tick.
 
 For example:
 
 p=<-6,0,0>, v=< 3,0,0>, a=< 0,0,0>
 p=<-4,0,0>, v=< 2,0,0>, a=< 0,0,0>    -6 -5 -4 -3 -2 -1  0  1  2  3
 p=<-2,0,0>, v=< 1,0,0>, a=< 0,0,0>    (0)   (1)   (2)            (3)
 p=< 3,0,0>, v=<-1,0,0>, a=< 0,0,0>
 
 p=<-3,0,0>, v=< 3,0,0>, a=< 0,0,0>
 p=<-2,0,0>, v=< 2,0,0>, a=< 0,0,0>    -6 -5 -4 -3 -2 -1  0  1  2  3
 p=<-1,0,0>, v=< 1,0,0>, a=< 0,0,0>             (0)(1)(2)      (3)
 p=< 2,0,0>, v=<-1,0,0>, a=< 0,0,0>
 
 p=< 0,0,0>, v=< 3,0,0>, a=< 0,0,0>
 p=< 0,0,0>, v=< 2,0,0>, a=< 0,0,0>    -6 -5 -4 -3 -2 -1  0  1  2  3
 p=< 0,0,0>, v=< 1,0,0>, a=< 0,0,0>                       X (3)
 p=< 1,0,0>, v=<-1,0,0>, a=< 0,0,0>
 
 ------destroyed by collision------
 ------destroyed by collision------    -6 -5 -4 -3 -2 -1  0  1  2  3
 ------destroyed by collision------                      (3)
 p=< 0,0,0>, v=<-1,0,0>, a=< 0,0,0>
 In this example, particles 0, 1, and 2 are simultaneously destroyed at the time and place marked X. On the next tick, particle 3 passes through unharmed.
 
 How many particles are left after all collisions are resolved?
 
 Your puzzle answer was 438.
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
    let sum = debug.reduce(0, combine: +)
    print("Removed: " + debug.description + " Sum: " + sum)
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
