import XCTest
@testable import AdventOfCode2021

final class Day3Tests: XCTestCase {
    
    func testMostCommonBit() throws {
        
        let lines = try Utility.readLines(from: "Day3.txt")
        
        var prevalenceOfZero = Array(repeating: 0, count: lines.first!.count)
        var prevalenceOfOne = Array(repeating: 0, count: lines.first!.count)
        
        lines.forEach { line in
            line.enumerated().forEach {
                if $1 == "0" {
                    prevalenceOfZero[$0] += 1
                } else {
                    prevalenceOfOne[$0] += 1
                }
            }
        }
        
        var gammaString = ""
        var epsilonString = ""
        for i in 0..<prevalenceOfZero.count {
            gammaString += (prevalenceOfZero[i] > prevalenceOfOne[i]) ? "0" : "1"
            epsilonString += (prevalenceOfZero[i] > prevalenceOfOne[i]) ? "1" : "0"
        }
                
        let gamma = UInt(gammaString, radix: 2)!
        let epsilon = UInt(epsilonString, radix: 2)!
        
        XCTAssertEqual(gamma, 1337)
        XCTAssertEqual(epsilon, 2758)
    }
    
    func testFindLifeSupportRating() throws {
        
        typealias BitGrid = [[Bool]]

        let lines = try Utility.readLines(from: "Day3.txt")
                
        var workingSet: BitGrid = lines.map { $0.map { $0 == "0" ? false : true } }
        
        for column in 0..<lines.first!.count {
            guard workingSet.count > 1 else { break }
            let groups = workingSet.reduce(into: [Int: BitGrid]()) { result, bits in
                if bits[column] == false {
                    result[0, default: []].append(bits)
                } else {
                    result[1, default: []].append(bits)
                }
            }
            if groups[1, default: []].count >= groups[0, default: []].count {
                workingSet = groups[1, default: []]
            } else {
                workingSet = groups[0, default: []]
            }
        }
        
        let oxygenGeneratorRatingString = workingSet.first!.map { $0 ? "1" : "0" }.joined()
        let oxygenGeneratorRating = UInt(oxygenGeneratorRatingString, radix: 2)!
        
        workingSet = lines.map { $0.map { $0 == "0" ? false : true } }
        
        for column in 0..<lines.first!.count {
            guard workingSet.count > 1 else { break }
            let groups = workingSet.reduce(into: [Int: BitGrid]()) { result, bits in
                if bits[column] == false {
                    result[0, default: []].append(bits)
                } else {
                    result[1, default: []].append(bits)
                }
            }
            if groups[0, default: []].count <= groups[1, default: []].count {
                workingSet = groups[0, default: []]
            } else {
                workingSet = groups[1, default: []]
            }
        }
        
        let carbonDioxideScrubberRatingString = workingSet.first!.map { $0 ? "1" : "0" }.joined()
        let carbonDioxideScrubberRating = UInt(carbonDioxideScrubberRatingString, radix: 2)!
        
        XCTAssertEqual(oxygenGeneratorRating, 1599)
        XCTAssertEqual(carbonDioxideScrubberRating, 2756)
    }
}
