//
//  numMatrices.swift
//  event021
//
//  Created by Lubomír Kaštovský on 24/12/2017.
//  Copyright © 2017 Avast. All rights reserved.
//

import Foundation

typealias ItemType = UInt8
typealias MatrixType = Array<Array<ItemType>>

struct PatternToMatch {
    var str: String
    var matrixArr: Array<MatrixType>
}

typealias TransformRulesType = Dictionary<String, Array<Array<UInt8>>>
typealias MatchingRulesType = Dictionary<Int, Array<PatternToMatch>>



func patternToMatrix(pattern: String) -> MatrixType {
    let args = pattern.components(separatedBy: "/")
    var matrix = MatrixType()
    if args.count == 2 {
        matrix = [[0,0],[0,0]]
    }
    else {
        if args.count == 3 {
            matrix = [[0,0,0],[0,0,0],[0,0,0]]
        }
        else {
            matrix = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
        }
    }
    for y in 0..<args.count {
        let arr = Array(args[y])
        for x in 0..<arr.count {
            if arr[x] == "." {
                matrix[y][x] = 0
            }
            else {
                matrix[y][x] = 1
            }
        }
    }
    return matrix
}

func matrixToPattern(matrix: MatrixType) -> String {
    var str = ""
    for y in 0..<matrix.count {
        for x in 0..<matrix[y].count {
            if matrix[y][x] == 0 {
                str += "."
            }
            else {
                str += "#"
            }
        }
        str += "/"
    }
    str.removeLast()
    return str
}

func rotate2(pattern: MatrixType) -> MatrixType {
    if pattern.count == 2 {
        var p: MatrixType = [[0,0],[0,0]]
        p[0][0] = pattern[1][0]
        p[0][1] = pattern[0][0]
        p[1][0] = pattern[1][1]
        p[1][1] = pattern[0][1]
        return p
    }
    else {
        var p: MatrixType = [[0,0,0],[0,0,0],[0,0,0]]
        p[0][0] = pattern[2][0]
        p[0][1] = pattern[1][0]
        p[0][2] = pattern[0][0]
        
        p[1][0] = pattern[2][1]
        p[1][1] = pattern[1][1]
        p[1][2] = pattern[0][1]
        
        p[2][0] = pattern[2][2]
        p[2][1] = pattern[1][2]
        p[2][2] = pattern[0][2]
        return p
    }
}

func flipVertical2(pattern: MatrixType) -> MatrixType {
    if pattern.count == 2 {
        return [pattern[1], pattern[0]]
    }
    else {
        return [pattern[2], pattern[1], pattern[0]]
    }
}

func compareMatrices(matrix1: MatrixType, matrix2: MatrixType) -> Bool {
    for i in 0..<matrix1.count {
        if matrix1[i] != matrix2[i] {
            return false
        }
    }
    return true
}

func haveSameMatrix(matrix: MatrixType, matrices: Array<MatrixType>) -> Bool {
    for m in matrices {
        if compareMatrices(matrix1: matrix, matrix2: m) {
            return true
        }
    }
    return false
}

func prepareRules(inputLines: Array<String>) -> TransformRulesType {
    var rules = TransformRulesType()
    for line in inputLines {
        let args = line.components(separatedBy:" => ")
        rules[args[0]] = patternToMatrix(pattern: args[1])
    }
    return rules
}

func prepareMatchingRules(inputLines: Array<String>) -> MatchingRulesType {
    var patterns = MatchingRulesType()
    patterns[2] = [PatternToMatch]()
    patterns[3] = [PatternToMatch]()
    for line in inputLines {
        let args = line.components(separatedBy:" => ")
        let side = args[0].components(separatedBy: "/").count
        var matrixArr = [MatrixType]()
        var m = patternToMatrix(pattern: args[0])
        for _ in 0..<4 {
            if !haveSameMatrix(matrix: m, matrices: matrixArr) {
                matrixArr.append(m)
            }
            let f = flipVertical2(pattern: m)
            if !haveSameMatrix(matrix: f, matrices: matrixArr) {
                matrixArr.append(f)
            }
            m = rotate2(pattern: m)
        }
        let p = PatternToMatch(str: args[0], matrixArr: matrixArr)
        patterns[side]!.append(p)
    }
    return patterns
}


func findReplacingPatern(matrix: MatrixType, transformRules: TransformRulesType, matchingRules: MatchingRulesType) -> MatrixType {
    var resMat = MatrixType()
    return resMat
}

func createMatrix(steps: Int, inputPattern: String) -> MatrixType {
    var resMat = MatrixType()
    var matrix = patternToMatrix(pattern: inputPattern)
    
    for n in 0..<steps {
        
    }
    return resMat
}




