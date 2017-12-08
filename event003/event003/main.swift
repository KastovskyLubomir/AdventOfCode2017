//
//  main.swift
//  event003
//
//  Created by Lubomír Kaštovský on 03/12/2017.
//  Copyright © 2017 Lubomír Kaštovský. All rights reserved.
//

/*

--- Day 3: Spiral Memory ---

You come across an experimental new kind of memory stored on an infinite two-dimensional grid.

Each square on the grid is allocated in a spiral pattern starting at a location marked 1 and then counting up while spiraling outward. For example, the first few squares are allocated like this:

17  16  15  14  13
18   5   4   3  12
19   6   1   2  11
20   7   8   9  10
21  22  23---> ...
While this is very space-efficient (no squares are skipped), requested data must be carried back to square 1 (the location of the only access port for this memory system) by programs that can only move up, down, left, or right. They always take the shortest path: the Manhattan Distance between the location of the data and square 1.

For example:

Data from square 1 is carried 0 steps, since it's at the access port.
Data from square 12 is carried 3 steps, such as: down, left, left.
Data from square 23 is carried only 2 steps: up twice.
Data from square 1024 must be carried 31 steps.
How many steps are required to carry the data from the square identified in your puzzle input all the way to the access port?

Your puzzle answer was 438.

--- Part Two ---

As a stress test on the system, the programs here clear the grid and then store the value 1 in square 1. Then, in the same allocation order as shown above, they store the sum of the values in all adjacent squares, including diagonals.

So, the first few squares' values are chosen as follows:

Square 1 starts with the value 1.
Square 2 has only one adjacent filled square (with value 1), so it also stores 1.
Square 3 has both of the above squares as neighbors and stores the sum of their values, 2.
Square 4 has all three of the aforementioned squares as neighbors and stores the sum of their values, 4.
Square 5 only has the first and fourth squares as neighbors, so it gets the value 5.
Once a square is written, its value does not change. Therefore, the first few squares would receive the following values:

147  142  133  122   59
304    5    4    2   57
330   10    1    1   54
351   11   23   25   26
362  747  806--->   ...
What is the first value written that is larger than your puzzle input?

Your puzzle answer was 266330.

*/

import Foundation

let destination = 265149
//let destination = 51
var corner_a = 1;
let const_a = 8;
var corner_b = 1;
let const_b = 1;
var corner_c = 1;
let const_c = 2;
var corner_d = 1;
let const_d = 3;
var corner_e = 1;
let const_e = 4;
var corner_f = 1;
let const_f = 5;
var corner_g = 1;
let const_g = 6;
var corner_h = 1;
let const_h = 7;

var iteration = 0;
var row_a = 0;

while (corner_a < destination) {
    corner_a = corner_a + (const_a + (iteration*8))
    corner_b = corner_b + (const_b + (iteration*8))
    corner_c = corner_c + (const_c + (iteration*8))
    corner_d = corner_d + (const_d + (iteration*8))
    corner_e = corner_e + (const_e + (iteration*8))
    corner_f = corner_f + (const_f + (iteration*8))
    corner_g = corner_g + (const_g + (iteration*8))
    corner_h = corner_h + (const_h + (iteration*8))
    row_a = iteration
    iteration += 1
}

print("iteration: " + String(iteration) + "> b:" + String(corner_b))
print("iteration: " + String(iteration) + "> c:" + String(corner_c))
print("iteration: " + String(iteration) + "> d:" + String(corner_d))
print("iteration: " + String(iteration) + "> e:" + String(corner_e))
print("iteration: " + String(iteration) + "> f:" + String(corner_f))
print("iteration: " + String(iteration) + "> g:" + String(corner_g))
print("iteration: " + String(iteration) + "> h:" + String(corner_h))
print("iteration: " + String(iteration) + "> a:" + String(corner_a) + "\n")


let X = 9
let Y = 9
let SIZE = 9

var arr = Array(repeating: Array(repeating: 0, count: SIZE), count: SIZE)

arr[X/2][Y/2] = 1

func addNeigbours(size: Int, x: Int, y: Int) -> Int {
    
    var sum: Int = 0
    
    if (((x-1) >= 0) && ((y-1) >= 0)) {
        sum += arr[x-1][y-1]
    }
    if ((x-1) >= 0) {
        sum += arr[x-1][y]
    }
    if (((x-1) >= 0) && ((y+1) < size)) {
        sum += arr[x-1][y+1]
    }
    if ((y-1) >= 0) {
        sum += arr[x][y-1]
    }
    if ((y+1) < size) {
        sum += arr[x][y+1]
    }
    if (((x+1) < size) && ((y-1) >= 0)) {
        sum += arr[x+1][y-1]
    }
    if ((x+1) < size)  {
        sum += arr[x+1][y]
    }
    if (((x+1) < size) && ((y+1) < size)) {
        sum += arr[x+1][y+1]
    }
    return sum
}

var index: Int = 1
var x = (X/2) + 1
var y = (Y/2)

enum Direction {
    case UP, DOWN, LEFT, RIGHT
}

var direction:Direction = Direction.UP

while (index < (X*Y)) {
    
    arr[x][y] = addNeigbours(size:SIZE, x: x, y: y)
    
    switch(direction) {
        case Direction.UP:
            if(arr[x-1][y] == 0) {
                direction = Direction.LEFT
                x = x-1
            }
            else {
                y = y-1
            }
            break;
        case Direction.LEFT:
            if(arr[x][y+1] == 0) {
                direction = Direction.DOWN
                y = y+1
            }
            else {
                x = x-1
            }
            break;
        case Direction.DOWN:
            if(arr[x+1][y] == 0) {
                direction = Direction.RIGHT
                x = x+1
            }
            else {
                y = y+1
            }
            break;
        case Direction.RIGHT:
            if(arr[x][y-1] == 0) {
                direction = Direction.UP
                y = y-1
            }
            else {
                x = x+1
            }
            break;
        default:break;
    }
    index+=1;
}

var a = 0
var b = 0
for row in arr {
    a = 0
    for num in row {
        print(String(arr[a][b]) + " ", terminator: "")
        a += 1
    }
    print("\n")
    b += 1
}

