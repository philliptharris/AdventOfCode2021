struct Day1 {
    
    static func calculateNumberOfIncreases(_ depths: [Int]) -> Int {
        guard depths.count > 1 else { return 0 }
        var numberOfIncreases = 0
        for i in 1..<depths.count {
            if depths[i] > depths[i - 1] {
                numberOfIncreases += 1
            }
        }
        return numberOfIncreases
    }
    
    static func calculateNumberOfIncreasesWithSlidingWindow(_ depths: [Int]) -> Int {
        guard depths.count > 3 else { return 0 }
        var numberOfIncreases = 0
        for i in 1...(depths.count - 3) {
            let sum = depths[i..<(i + 3)].reduce(0, +)
            let previousSum = depths[(i - 1)..<(i - 1 + 3)].reduce(0, +)
            if sum > previousSum {
                numberOfIncreases += 1
            }
        }
        return numberOfIncreases
    }
}
