import XCTest
@testable import AdventOfCode2021

final class Day14Tests: XCTestCase {
    
    func testRunPolymerization() throws {
                
        let lookup = try loadLookupTable()
        
        var polymer = "OOFNFCBHCKBBVNHBNVCP"
        
        for step in 1...10 {
            print("STEP \(step), POLYMER LENGTH = \(polymer.count)")
            let characters = polymer.map { $0 }
            var output = "\(characters.first!)"
            for i in 1..<characters.count {
                let left = characters[i - 1]
                let right = characters[i]
                let middle = lookup["\(left)\(right)"]!
                output += "\(middle)\(right)"
            }
            polymer = output
        }
                
        let frequencies = Set(polymer).reduce(into: [Character: Int]()) { result, character in
            result[character] = polymer.filter { $0 == character }.count
        }
        
        let sorted = frequencies.sorted { $0.value < $1.value }
        
        let answer = sorted.last!.value - sorted.first!.value
        
        XCTAssertEqual(answer, 2899)
    }
    
    func testRunPolymerizationEfficiently() throws {
        
        let lookup = try loadLookupTable()
        
        let polymer = "OOFNFCBHCKBBVNHBNVCP"
        
        var characterFrequencies = polymer.reduce(into: [Character: Int]()) {
            $0[$1, default: 0] += 1
        }
        
        var pairFrequencies: [String: Int] = [:]
        let characters = polymer.map { $0 }
        for i in 1..<characters.count {
            let left = characters[i - 1]
            let right = characters[i]
            pairFrequencies["\(left)\(right)", default: 0] += 1
        }
        
        for step in 1...40 {
            print("Step: \(step), pairFrequencies.count = \(pairFrequencies.count)")
            let newPairFrequencies = pairFrequencies.reduce(into: [String: Int]()) { result, pairFrequency in
                let character = lookup[pairFrequency.key]!
                characterFrequencies[character, default: 0] += pairFrequency.value
                result["\(pairFrequency.key.first!)\(character)", default: 0] += pairFrequency.value
                result["\(character)\(pairFrequency.key.last!)", default: 0] += pairFrequency.value
            }
            pairFrequencies = newPairFrequencies
        }
        
        let sorted = characterFrequencies.sorted { $0.value < $1.value }
        
        let answer = sorted.last!.value - sorted.first!.value
        
        XCTAssertEqual(answer, 3528317079545)
    }
    
    private func loadLookupTable() throws -> [String: Character] {
        
        try Utility.readLines(from: "Day14.txt").reduce(into: [String: Character]()) {
            let pair = $1.components(separatedBy: " -> ")
            $0[pair.first!] = Character(pair.last!)
        }
    }
}
