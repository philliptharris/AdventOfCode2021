import XCTest
@testable import AdventOfCode2021

final class Day13Tests: XCTestCase {
    
    struct Point: Hashable {
        var x: Int
        var y: Int
        init?(string: String) {
            let pair = string.split(separator: ",")
            guard pair.count == 2 else { return nil }
            guard let first = pair.first, let x = Int(first) else { return nil }
            guard let last = pair.last, let y = Int(last) else { return nil }
            self.x = x
            self.y = y
        }
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }
    
    struct Fold {
        let axis: Axis
        let value: Int
        enum Axis: String {
            case x
            case y
        }
        init?(string: String) {
            let pair = string.replacingOccurrences(of: "fold along ", with: "").split(separator: "=")
            guard pair.count == 2 else { return nil }
            guard let first = pair.first, let axis = Axis(rawValue: String(first)) else { return nil }
            guard let last = pair.last, let value = Int(last) else { return nil }
            self.axis = axis
            self.value = value
        }
        init(axis: Axis, value: Int) {
            self.axis = axis
            self.value = value
        }
    }
    
    func testFirstFold() throws {
        
        let lines = try Utility.readLines(from: "Day13.txt")
        
        let points = lines.map { Point(string: $0)! }
        
        let result = fold(points: Set(points), at: Fold(axis: .x, value: 655))
        
        XCTAssertEqual(result.count, 795)
    }
    
    func testRunAllFolds() throws {
        
        let lines = try Utility.readLines(from: "Day13.txt")
        
        let points = lines.map { Point(string: $0)! }
        
        let foldLines = try Utility.readLines(from: "Day13-folds.txt")
        
        let folds = foldLines.map { Fold(string: $0)! }
        
        var result = Set(points)
        folds.forEach { result = fold(points: result, at: $0) }
        
        let maxX = result.map { $0.x }.max()!
        let maxY = result.map { $0.y }.max()!
        
        var matrix = Array(repeating: Array(repeating: " ", count: maxX + 1), count: maxY + 1)
        
        result.forEach { matrix[$0.y][$0.x] = "#" }
        
        let output = matrix.map { $0.joined() }.joined(separator: "\n")
        
        print("")
        print(output)
        print("")
    }
    
    private func fold(points: Set<Point>, at fold: Fold) -> Set<Point> {
        
        switch fold.axis {
        case .x:
            let leftPoints = points.filter { $0.x < fold.value }
            let rightPoints = points.filter { $0.x > fold.value }
            let foldedPoints = rightPoints.map { Point(x: fold.value - ($0.x - fold.value), y: $0.y) }
            var combinedPoints: Set<Point> = Set(leftPoints)
            combinedPoints.formUnion(foldedPoints)
            return combinedPoints
        case .y:
            let topPoints = points.filter { $0.y < fold.value }
            let bottomPoints = points.filter { $0.y > fold.value }
            let foldedPoints = bottomPoints.map { Point(x: $0.x, y: fold.value - ($0.y - fold.value)) }
            var combinedPoints: Set<Point> = Set(topPoints)
            combinedPoints.formUnion(foldedPoints)
            return combinedPoints
        }
    }
}
