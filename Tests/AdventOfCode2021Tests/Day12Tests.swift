import XCTest
@testable import AdventOfCode2021

final class Day12Tests: XCTestCase {
    
    class Cave: Equatable, Hashable {
        static func == (lhs: Day12Tests.Cave, rhs: Day12Tests.Cave) -> Bool {
            lhs.name == rhs.name
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }
        let name: String
        lazy private(set) var isLarge: Bool = (name.uppercased() == name)
        var connections: Set<Cave> = []
        init(name: String) {
            self.name = name
        }
    }
    
    func testFindNumberOfPathsThroughCaveSystem() throws {
        
        let caveTopography = try loadCaveTopographyFromFile()
        
        guard let start = caveTopography["start"] else { fatalError() }
        guard let end = caveTopography["end"] else { fatalError() }
        
        let paths = findAllPossiblePaths(from: start, visited: [start])
        
        let nonDeadEndPaths = paths.filter { $0.last! == end }
                
        XCTAssertEqual(nonDeadEndPaths.count, 4970)
    }
    
    func testFindNumberOfPathsIfSingleSmallCaveCanBeVisitedTwice() throws {

        let caveTopography = try loadCaveTopographyFromFile()

        guard let start = caveTopography["start"] else { fatalError() }
        guard let end = caveTopography["end"] else { fatalError() }
        
        let smallCaves = caveTopography.values.filter { !($0.isLarge || $0 == start || $0 == end) }
        
        let allPaths = smallCaves.reduce(into: Set<[Cave]>()) { result, smallCave in
            let paths = findAllPossiblePaths(from: start, visited: [start], smallCaveThatYouCanVisitTwice: smallCave)
            let nonDeadEndPaths = paths.filter { $0.last! == end }
            result.formUnion(nonDeadEndPaths)
        }
        
        XCTAssertEqual(allPaths.count, 137948)
    }
    
    private func findAllPossiblePaths(from cave: Cave, visited: [Cave], smallCaveThatYouCanVisitTwice: Cave? = nil) -> [[Cave]] {
        
        let possibleNextCaves = cave.connections.filter { connection in
            if connection.isLarge {
                return true
            } else if let smallTwice = smallCaveThatYouCanVisitTwice, connection == smallTwice {
                return visited.filter { $0 == connection }.count < 2
            } else {
                return !visited.contains(connection)
            }
        }
        
        if cave.name == "end" {
            // The end
            return [visited]
        } else if possibleNextCaves.isEmpty {
            // Dead end
            return [visited]
        } else {
            let paths = possibleNextCaves.map { findAllPossiblePaths(from: $0, visited: visited + [$0], smallCaveThatYouCanVisitTwice: smallCaveThatYouCanVisitTwice) }.joined()
            return Array(paths)
        }
    }
    
    private func loadCaveTopographyFromFile() throws -> [String: Cave] {
        
        let lines = try Utility.readLines(from: "Day12.txt")
        
        let pairs = lines.map { $0.components(separatedBy: "-") }
        
        return pairs.reduce(into: [String: Cave]()) { result, pair in
            guard pair.count == 2 else { fatalError() }
            guard let name1 = pair.first else { fatalError() }
            guard let name2 = pair.last else { fatalError() }
            let cave1 = result[name1] ?? Cave(name: name1)
            let cave2 = result[name2] ?? Cave(name: name2)
            cave1.connections.insert(cave2)
            cave2.connections.insert(cave1)
            result[name1] = cave1
            result[name2] = cave2
        }
    }
}
