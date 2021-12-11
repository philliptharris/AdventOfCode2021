import XCTest
@testable import AdventOfCode2021

final class Day10Tests: XCTestCase {
    
    enum Opener: Character {
        case parens = "("
        case square = "["
        case curlie = "{"
        case angled = "<"
        var closer: Closer {
            switch self {
            case .parens: return .parens
            case .square: return .square
            case .curlie: return .curlie
            case .angled: return .angled
            }
        }
    }
    
    enum Closer: Character {
        case parens = ")"
        case square = "]"
        case curlie = "}"
        case angled = ">"
        var opener: Opener {
            switch self {
            case .parens: return .parens
            case .square: return .square
            case .curlie: return .curlie
            case .angled: return .angled
            }
        }
        var score: Int {
            switch self {
            case .parens: return 3
            case .square: return 57
            case .curlie: return 1197
            case .angled: return 25137
            }
        }
        var closingScore: Int {
            switch self {
            case .parens: return 1
            case .square: return 2
            case .curlie: return 3
            case .angled: return 4
            }
        }
    }
    
    func testFindCorruptedLines() throws {
        
        let lines = try Utility.readLines(from: "Day10.txt")
        
        let corruptedLines = lines.compactMap { findCorruption(on: $0) }
        
        let totalScore = corruptedLines
            .map { Closer(rawValue: $0)! }
            .map { $0.score }
            .reduce(0, +)
        
        XCTAssertEqual(totalScore, 271245)
    }
    
    func testFinishIncompleteLines() throws {
        
        let lines = try Utility.readLines(from: "Day10.txt")
        
        let incompleteLines = lines.filter { findCorruption(on: $0) == nil }
        
        let closers = incompleteLines.map { findSequenceOfClosers(for: $0) }
        
        var scores = closers.map {
            $0.reduce(0) { ($0 * 5) + $1.closingScore }
        }
        
        scores.sort()
        
        let middleScore = scores[scores.count / 2]
        
        XCTAssertEqual(middleScore, 1685293086)
    }
    
    private func findCorruption(on line: String) -> Character? {
        
        var danglingOpeners: [Opener] = []
        
        for character in line {
            if let opener = Opener(rawValue: character) {
                danglingOpeners.append(opener)
            } else if let closer = Closer(rawValue: character) {
                if danglingOpeners.isEmpty || danglingOpeners.removeLast().closer != closer {
                    return character
                }
            }
        }
        
        return nil
    }
    
    private func findSequenceOfClosers(for incompleteLine: String) -> [Closer] {
        
        var danglingOpeners: [Opener] = []
        
        for character in incompleteLine {
            if let opener = Opener(rawValue: character) {
                danglingOpeners.append(opener)
            } else if let closer = Closer(rawValue: character) {
                if danglingOpeners.isEmpty || danglingOpeners.removeLast().closer != closer {
                    fatalError()
                }
            }
        }
        
        return danglingOpeners.reversed().map { $0.closer }
    }
}
