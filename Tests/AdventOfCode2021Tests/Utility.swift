import Foundation

final class Utility {
    
    private init() {}
    
    static func readLines(from file: String) throws -> [String] {
        let url = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(file)
        return try String(contentsOf: url, encoding: .utf8)
            .split { $0.isNewline }
            .map { String($0) }
    }
}
