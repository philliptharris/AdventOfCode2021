import XCTest
@testable import AdventOfCode2021

final class Day5Tests: XCTestCase {
    
    struct Point: Hashable {
        let x: Int
        let y: Int
        init(_ string: String) {
            let coordinates = string.split(separator: ",").map { Int($0)! }
            guard coordinates.count == 2 else { fatalError() }
            x = coordinates.first!
            y = coordinates.last!
        }
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }
    
    struct Line {
        let a: Point
        let b: Point
        init(_ string: String) {
            let points = string.components(separatedBy: " -> ")
            guard points.count == 2 else { fatalError() }
            a = Point(points.first!)
            b = Point(points.last!)
        }
        func isHorizontal() -> Bool {
            a.y == b.y
        }
        func isVertical() -> Bool {
            a.x == b.x
        }
        func pointsFromAtoB() -> [Point] {
            let xVals = Array(stride(from: a.x, through: b.x, by: b.x > a.x ? 1 : -1))
            let yVals = Array(stride(from: a.y, through: b.y, by: b.y > a.y ? 1 : -1))
            var points: [Point] = []
            if a.x == b.x {
                points = yVals.map { Point(x: a.x, y: $0) }
            } else if a.y == b.y {
                points = xVals.map { Point(x: $0, y: a.y) }
            } else {
                guard xVals.count == yVals.count else { fatalError() }
                for i in 0..<xVals.count {
                    let x = xVals[i]
                    let y = yVals[i]
                    points.append(Point(x: x, y: y))
                }
            }
            return points
        }
    }
    
    func testLines() throws {
        
        var lines = try Utility.readLines(from: "Day5.txt").map { Line($0) }
        
        lines = lines.filter { $0.isHorizontal() || $0.isVertical() }
        
        var field = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
        
        lines.forEach { line in
            if line.isHorizontal() {
                var row = field[line.a.y]
                for c in min(line.a.x, line.b.x)...max(line.a.x, line.b.x) {
                    row[c] += 1
                }
                field[line.a.y] = row
            } else if line.isVertical() {
                for r in min(line.a.y, line.b.y)...max(line.a.y, line.b.y) {
                    var row = field[r]
                    row[line.a.x] += 1
                    field[r] = row
                }
            }
        }
        
        let pointsWhereAtLeastTwoLinesOverlap = field.joined().filter { $0 >= 2 }
        
        XCTAssertEqual(pointsWhereAtLeastTwoLinesOverlap.count, 7438)
    }
    
    func testDiagonalLines() throws {
        
        let lines = try Utility.readLines(from: "Day5.txt").map { Line($0) }
        
        var field: [Point: Int] = [:]
        (0..<1000).forEach { row in
            (0..<1000).forEach { col in
                let point = Point(x: col, y: row)
                field[point] = 0
            }
        }
        
        lines.forEach { line in
            line.pointsFromAtoB().forEach { point in
                field[point]! += 1
            }
        }
        
        let pointsWhereAtLeastTwoLinesOverlap = field.filter { $0.value >= 2 }
        
        XCTAssertEqual(pointsWhereAtLeastTwoLinesOverlap.count, 21406)
    }
}
