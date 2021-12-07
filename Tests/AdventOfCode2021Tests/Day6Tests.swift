import XCTest
@testable import AdventOfCode2021

final class Day6Tests: XCTestCase {
    
    static let fish = [1,1,3,5,1,3,2,1,5,3,1,4,4,4,1,1,1,3,1,4,3,1,2,2,2,4,1,1,5,5,4,3,1,1,1,1,1,1,3,4,1,2,2,5,1,3,5,1,3,2,5,2,2,4,1,1,1,4,3,3,3,1,1,1,1,3,1,3,3,4,4,1,1,5,4,2,2,5,4,5,2,5,1,4,2,1,5,5,5,4,3,1,1,4,1,1,3,1,3,4,1,1,2,4,2,1,1,2,3,1,1,1,4,1,3,5,5,5,5,1,2,2,1,3,1,2,5,1,4,4,5,5,4,1,1,3,3,1,5,1,1,4,1,3,3,2,4,2,4,1,5,5,1,2,5,1,5,4,3,1,1,1,5,4,1,1,4,1,2,3,1,3,5,1,1,1,2,4,5,5,5,4,1,4,1,4,1,1,1,1,1,5,2,1,1,1,1,2,3,1,4,5,5,2,4,1,5,1,3,1,4,1,1,1,4,2,3,2,3,1,5,2,1,1,4,2,1,1,5,1,4,1,1,5,5,4,3,5,1,4,3,4,4,5,1,1,1,2,1,1,2,1,1,3,2,4,5,3,5,1,2,2,2,5,1,2,5,3,5,1,1,4,5,2,1,4,1,5,2,1,1,2,5,4,1,3,5,3,1,1,3,1,4,4,2,2,4,3,1,1]
    
    func testFishPopulation() {
        
        var fish = Self.fish
        
        (1...80).forEach { day in
            var nBabies = 0
            for f in 0..<fish.count {
                if fish[f] == 0 {
                    nBabies += 1
                    fish[f] = 6
                } else {
                    fish[f] -= 1
                }
            }
            fish.append(contentsOf: Array(repeating: 8, count: nBabies))
            print("📆 DAY \(day), 🐠 \(fish.count)")
        }
        
        XCTAssertEqual(fish.count, 360610)
    }
    
    func testFishPopulationEfficiently() {
        
        var fishLookup = Self.fish.reduce(into: [Int: Int]()) {
            $0[$1, default: 0] += 1
        }
        
        (1...256).forEach { day in
            let nBabies = fishLookup[0, default: 0]
            var newFishLookup: [Int: Int] = [:]
            fishLookup.forEach {
                if $0.key == 0 {
                    newFishLookup[6, default: 0] += $0.value
                } else {
                    newFishLookup[$0.key - 1, default: 0] += $0.value
                }
            }
            newFishLookup[8, default: 0] += nBabies
            fishLookup = newFishLookup
            print("📆 DAY \(day), 🐠 \(fishLookup.values.reduce(0, +))")
        }
        
        let fishCount = fishLookup.values.reduce(0, +)
        
        XCTAssertEqual(fishCount, 1631629590423)
    }
}
