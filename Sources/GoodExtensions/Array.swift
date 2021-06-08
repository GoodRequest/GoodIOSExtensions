//
//  Array.swift
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2019 GoodRequest. All rights reserved.
//

import Foundation
import GRCompatible

extension Collection where Self: GRCompatible { }

public extension GRActive where Base: Collection {
    
    /// Returns array of elements where between each element will be inserted element, provided in parameter.
    ///
    /// - returns: list separated by element in parameter
    func separated(by element: Base.Element) -> [Base.Element] {
        return Array(base.map { [$0] }.joined(separator: [element]))
    }
    
    /// Returns true if array contains item with specified index, otherwise returns false.
    ///
    /// - returns: true or false whether the array contains specified index.
    func contains(index: Int) -> Bool {
        return (base.startIndex..<base.endIndex).contains(index as! Base.Index)
    }
    
}

public extension Array {
    
    subscript(safe index: Int) -> Element? {
        self.gr.contains(index: index) ? self[index] : nil
    }
    
}

public extension Array where Element: Equatable {
    
    mutating func removeOrAppend(object: Element) {
        if contains(object) {
            removeAll(where: { $0 == object })
        } else {
            append(object)
        }
    }
    
}

public extension Array where Element == String? {

    func joinNonNil(separator: String = "") -> String {
        return self.compactMap{ $0 }.joined(separator: separator)
    }

}

public extension Array {

    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

}

public extension Array where Element: Equatable {

    /// https://github.com/SwifterSwift/SwifterSwift/blob/master

    /// SwifterSwift: Insert an element at the beginning of array.
    ///
    ///        [2, 3, 4, 5].prepend(1) -> [1, 2, 3, 4, 5]
    ///        ["e", "l", "l", "o"].prepend("h") -> ["h", "e", "l", "l", "o"]
    ///
    /// - Parameter newElement: element to insert.
    mutating func prepend(_ newElement: Element) {
        insert(newElement, at: 0)
    }

    /// SwifterSwift: Safely swap values at given index positions.
    ///
    ///        [1, 2, 3, 4, 5].safeSwap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
    ///        ["h", "e", "l", "l", "o"].safeSwap(from: 1, to: 0) -> ["e", "h", "l", "l", "o"]
    ///
    /// - Parameters:
    ///   - index: index of first element.
    ///   - otherIndex: index of other element.
    mutating func safeSwap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex..<endIndex ~= index else { return }
        guard startIndex..<endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }

    /// SwifterSwift: Remove all duplicate elements from Array.
    ///
    ///        [1, 2, 2, 3, 4, 5].removeDuplicates() -> [1, 2, 3, 4, 5]
    ///        ["h", "e", "l", "l", "o"]. removeDuplicates() -> ["h", "e", "l", "o"]
    ///
    /// - Returns: Return array with all duplicate elements removed.
    @discardableResult
    mutating func removeDuplicates() -> [Element] {
        // Thanks to https://github.com/sairamkotha for improving the method
        self = reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
        return self
    }

    /// SwifterSwift: Return array with all duplicate elements removed.
    ///
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].withoutDuplicates() -> [1, 2, 3, 4, 5])
    ///     ["h", "e", "l", "l", "o"].withoutDuplicates() -> ["h", "e", "l", "o"])
    ///
    /// - Returns: an array of unique elements.
    ///
    func withoutDuplicates() -> [Element] {
        // Thanks to https://github.com/sairamkotha for improving the method
        return reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }

}
