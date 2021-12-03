import XCTest
@testable import AdventOfCode2021

final class Day2Tests: XCTestCase {
    
    func testDepthAndPosition() throws {
        var position = 0
        var depth = 0
        let commands = try loadInputFile()
        commands.forEach {
            switch $0.direction {
            case .forward: position += $0.amount
            case .up: depth -= $0.amount
            case .down: depth += $0.amount
            }
        }
        print("position = \(position) depth = \(depth) product = \(position * depth)")
    }
    
    func testDepthAndPositionViaAim() throws {
        var position = 0
        var depth = 0
        var aim = 0
        let commands = try loadInputFile()
        commands.forEach {
            switch $0.direction {
            case .forward:
                position += $0.amount
                depth += $0.amount * aim
            case .up: aim -= $0.amount
            case .down: aim += $0.amount
            }
        }
        print("position = \(position) depth = \(depth) product = \(position * depth)")
    }
    
    private func loadInputFile() throws -> [Command] {
        let url = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("Day2.txt")
        let contents = try String(contentsOf: url, encoding: .utf8)
        let lines = contents.split { $0.isNewline }
        return lines.map { Command(commandString: String($0))! }
    }
    
    private struct Command {
        let direction: Direction
        let amount: Int
        init?(commandString: String) {
            let pair = commandString.split(separator: " ")
            guard pair.count == 2 else { return nil }
            guard let direction = (pair.first.map { Direction(rawValue: String($0)) } ?? nil) else { return nil }
            guard let amount = (pair.last.map { Int($0) } ?? nil) else { return nil }
            self.direction = direction
            self.amount = amount
        }
    }
    
    private enum Direction: String {
        case forward
        case up
        case down
    }
}
