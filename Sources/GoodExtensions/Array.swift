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
