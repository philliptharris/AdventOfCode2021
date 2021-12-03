import XCTest
@testable import AdventOfCode2021

final class Day1Tests: XCTestCase {
    
    func testNumberOfIncreases() throws {
        
        let depths = try Utility.readLines(from: "Day1.txt").map { Int($0)! }
        
        XCTAssertEqual(Day1.calculateNumberOfIncreases(depths), 1184)
        XCTAssertEqual(Day1.calculateNumberOfIncreasesWithSlidingWindow(depths), 1158)
    }
}
