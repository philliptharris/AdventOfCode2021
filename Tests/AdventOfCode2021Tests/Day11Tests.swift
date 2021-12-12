import XCTest
@testable import AdventOfCode2021

final class Day11Tests: XCTestCase {
    
    struct IndexPath: Hashable {
        let row: Int
        let col: Int
    }
    
    func testNumberOfFlashes() throws {
        
        var octopuses = try loadOctopuses()
        
        var totalFlashes = 0
        
        for _ in 1...100 {
            
            performStep(on: &octopuses)
            
            totalFlashes += octopuses.filter { $0.value == 0 }.count
        }
        
        XCTAssertEqual(totalFlashes, 1683)
    }
    
    func testFindFirstStepWhenAllOctopusesFlashSimultaneously() throws {
        
        var octopuses = try loadOctopuses()
        
        var step = 0
        
        while octopuses.filter({ $0.value == 0 }).count < octopuses.count {
            
            step += 1
            
            performStep(on: &octopuses)
        }
        
        XCTAssertEqual(step, 788)
    }
    
    private func loadOctopuses() throws -> [IndexPath: Int] {
        
        let lines = try Utility.readLines(from: "Day11.txt")
        
        return lines.enumerated().reduce(into: [IndexPath: Int]()) { result, lineItem in
            lineItem.element.enumerated().forEach { characterItem in
                result[IndexPath(row: lineItem.offset, col: characterItem.offset)] = Int(String(characterItem.element))
            }
        }
    }
    
    private func performStep(on octopuses: inout [IndexPath: Int]) {
        
        octopuses = octopuses.mapValues { $0 + 1 }
        
        var octopusesThatHaveFlashed: Set<IndexPath> = []
        
        var fullyCharged = octopuses.filter { $0.value > 9 }
        
        while !fullyCharged.isEmpty {
            octopusesThatHaveFlashed.formUnion(fullyCharged.keys)
            fullyCharged.forEach {
                for r in -1...1 {
                    for c in -1...1 {
                        guard !(r == 0 && c == 0) else { continue }
                        octopuses[IndexPath(row: $0.key.row + r, col: $0.key.col + c)]? += 1
                    }
                }
            }
            fullyCharged = octopuses.filter { $0.value > 9 && !octopusesThatHaveFlashed.contains($0.key) }
        }
        
        octopusesThatHaveFlashed.forEach {
            octopuses[$0] = 0
        }
    }
}
