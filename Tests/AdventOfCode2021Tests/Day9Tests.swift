import XCTest
@testable import AdventOfCode2021

final class Day9Tests: XCTestCase {
    
    struct IndexPath: Hashable {
        let row: Int
        let col: Int
    }
    
    func testDepthMapLowPointRiskLevels() throws {
        
        let depths = try readDepths()
        
        let lowPoints = findLowPoints(in: depths)
        
        let riskLevels = lowPoints.values.map { $0 + 1 }
        
        let totalRisk = riskLevels.reduce(0, +)
        
        XCTAssertEqual(totalRisk, 554)
    }
    
    func testFindLargestBasins() throws {
        
        let depths = try readDepths()
        
        let lowPoints = findLowPoints(in: depths)
        
        let basins = lowPoints.map { findBasin(in: depths, at: ($0.key, $0.value)) }
        
        let sortedBasins = basins.sorted { $0.count < $1.count }
        
        let productOfThreeLargestBasinSizes = sortedBasins.suffix(3).reduce(1) { $0 * $1.count }
        
        XCTAssertEqual(productOfThreeLargestBasinSizes, 1017792)
    }
    
    private func readDepths() throws -> [IndexPath: Int] {
        
        let lines = try Utility.readLines(from: "Day9.txt")
        
        return lines.enumerated().reduce(into: [IndexPath: Int]()) { result, lineItem in
            lineItem.element.enumerated().forEach { characterItem in
                let indexPath = IndexPath(row: lineItem.offset, col: characterItem.offset)
                result[indexPath] = Int(String(characterItem.element))
            }
        }
    }
    
    private func findLowPoints(in depths: [IndexPath: Int]) -> [IndexPath: Int] {
        
        depths.filter {
            let ip = $0.key
            let up = depths[IndexPath(row: ip.row - 1, col: ip.col + 0)] ?? Int.max
            let dn = depths[IndexPath(row: ip.row + 1, col: ip.col + 0)] ?? Int.max
            let lf = depths[IndexPath(row: ip.row + 0, col: ip.col - 1)] ?? Int.max
            let rt = depths[IndexPath(row: ip.row + 0, col: ip.col + 1)] ?? Int.max
            let d = $0.value
            return d < up && d < dn && d < lf && d < rt
        }
    }
    
    private func findBasin(in depths: [IndexPath: Int], at lowPoint: (IndexPath, Int)) -> [IndexPath: Int] {
        
        var inTheBasin: [IndexPath: Int] = [lowPoint.0: lowPoint.1]
        
        var toExamine: [IndexPath: Int] = inTheBasin
        
        while !toExamine.isEmpty {
            
            let examine = toExamine.randomElement()!
            toExamine.removeValue(forKey: examine.key)
            
            let ip = examine.key
            let up = IndexPath(row: ip.row - 1, col: ip.col + 0)
            let dn = IndexPath(row: ip.row + 1, col: ip.col + 0)
            let lf = IndexPath(row: ip.row + 0, col: ip.col - 1)
            let rt = IndexPath(row: ip.row + 0, col: ip.col + 1)
            
            if let depth = depths[up], depth != 9, inTheBasin[up] == nil {
                inTheBasin[up] = depth
                toExamine[up] = depth
            }
            if let depth = depths[dn], depth != 9, inTheBasin[dn] == nil {
                inTheBasin[dn] = depth
                toExamine[dn] = depth
            }
            if let depth = depths[lf], depth != 9, inTheBasin[lf] == nil {
                inTheBasin[lf] = depth
                toExamine[lf] = depth
            }
            if let depth = depths[rt], depth != 9, inTheBasin[rt] == nil {
                inTheBasin[rt] = depth
                toExamine[rt] = depth
            }
        }
        
        return inTheBasin
    }
}
