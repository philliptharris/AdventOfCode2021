import XCTest
@testable import AdventOfCode2021

final class Day4Tests: XCTestCase {
    
    class BingoCard: Hashable {
        
        static func == (lhs: Day4Tests.BingoCard, rhs: Day4Tests.BingoCard) -> Bool {
            lhs.numbers == rhs.numbers
        }
        
        func hash(into hasher: inout Hasher) {
            let stringValue: String = numbers.map { $0.map { String($0) } }.joined().joined()
            hasher.combine(stringValue)
        }
        
        let numbers: [[Int]]
        
        var marked: [[Bool]]
        
        init(_ lines: [String]) {
            guard lines.count == 5 else { fatalError() }
            numbers = lines.map { line in
                line.split(separator: " ").map { Int($0)! }
            }
            marked = Array(repeating: Array(repeating: false, count: 5), count: 5)
        }
        
        func numberGotCalled(_ number: Int) {
            for row in 0..<5 {
                for column in 0..<5 {
                    if numbers[row][column] == number {
                        marked[row][column] = true
                    }
                }
            }
        }
        
        func isWinner() -> Bool {
            for row in marked {
                if row.filter({ $0 == true }).count == 5 { return true }
            }
            for c in 0..<5 {
                let column = marked.map { $0[c] }
                if column.filter({ $0 == true }).count == 5 { return true }
            }
            return false
        }
        
        func sumOfUnmarkedNumbers() -> Int {
            let allNumbers: [Int] = Array(numbers.joined())
            let allMarked: [Bool] = Array(marked.joined())
            return allNumbers.enumerated().reduce(0) {
                $0 + (allMarked[$1.offset] == false ? $1.element : 0)
            }
        }
    }
    
    func testBingo() throws {
                
        let lines = try Utility.readLines(from: "Day4.txt")
        
        let numbers = lines.first!.split(separator: ",").map { Int($0)! }
        
        let bingoCards = stride(from: 1, to: lines.count, by: 5).map { rowStart in
            BingoCard(Array(lines[rowStart..<(rowStart + 5)]))
        }
        
        var losingCards: Set<BingoCard> = Set(bingoCards)
        
        callingNumbersLoop: for n in 0..<numbers.count {
            let number = numbers[n]
            for card in losingCards {
                card.numberGotCalled(number)
                if card.isWinner() {
                    losingCards.remove(card)
                    if losingCards.isEmpty {
                        print("WE HAVE A WINNER!!! 🎉")
                        print(card.numbers)
                        print(number)
                        print(card.sumOfUnmarkedNumbers())
                    }
                }
            }
        }
    }
}
