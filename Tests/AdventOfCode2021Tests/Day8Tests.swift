import XCTest
@testable import AdventOfCode2021

final class Day8Tests: XCTestCase {
    
    struct Entry {
        
        let tenUniqueSignals: [String]
        let fourDigitOutput: [String]
        
        init(_ string: String) {
            let pair = string.split(separator: "|")
            guard pair.count == 2 else { fatalError() }
            tenUniqueSignals = pair.first!.split(separator: " ").map { String($0) }
            fourDigitOutput = pair.last!.split(separator: " ").map { String($0) }
        }
        
        func solve() -> [Set<Character>: String] {
            
            var solution: [Set<Character>: String] = [:]
            
            let tenUniqueSets: [Set<Character>] = tenUniqueSignals.map { Set($0) }
            
            let n1 = tenUniqueSets.first { $0.count == 2 }!
            let n7 = tenUniqueSets.first { $0.count == 3 }!
            let n4 = tenUniqueSets.first { $0.count == 4 }!
            let n8 = tenUniqueSets.first { $0.count == 7 }!
            
            let n2 = tenUniqueSets.first { $0.count == 5 && $0.intersection(n4).count == 2 }!
            let n3 = tenUniqueSets.first { $0.count == 5 && $0.intersection(n1).count == 2 }!
            let n5 = tenUniqueSets.first { $0.count == 5 && $0 != n2 && $0 != n3 }!
            
            let n6 = tenUniqueSets.first { $0.count == 6 && $0.intersection(n1).count == 1 }!
            let n9 = tenUniqueSets.first { $0.count == 6 && $0.intersection(n4).count == 4 }!
            let n0 = tenUniqueSets.first { $0.count == 6 && $0 != n6 && $0 != n9 }!
            
            solution[n0] = "0"
            solution[n1] = "1"
            solution[n2] = "2"
            solution[n3] = "3"
            solution[n4] = "4"
            solution[n5] = "5"
            solution[n6] = "6"
            solution[n7] = "7"
            solution[n8] = "8"
            solution[n9] = "9"
            
            return solution
        }
        
        func deduceOutput() -> Int {
            let solution = solve()
            return Int(fourDigitOutput.map { solution[Set($0)]! }.joined())!
        }
    }
    
    func testDigitsInOutput() throws {
        
        let entries = try Utility.readLines(from: "Day8.txt").map { Entry($0) }
        
        let validCounts: Set<Int> = [2, 3, 4, 7]
        
        let count = entries
            .map { $0.fourDigitOutput }
            .joined()
            .filter { validCounts.contains($0.count) }
            .count
        
        XCTAssertEqual(count, 456)
    }
    
    func testFindAllDigits() throws {
        
        let entries = try Utility.readLines(from: "Day8.txt").map { Entry($0) }
        
        let sum = entries.reduce(0) {
            $0 + $1.deduceOutput()
        }
        
        XCTAssertEqual(sum, 1091609)
    }
}
