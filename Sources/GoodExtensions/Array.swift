//
//  Array.swift
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2019 GoodRequest. All rights reserved.
//

import Foundation
import GRCompatible

public extension GRActive where Base: Collection {
    
    subscript(safe index: Int) -> Base.Element? {
        self.contains(index: index) ? base[index as! Base.Index] : nil
    }
    
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

//public extension GRActive where Base: Collection, Base.Element: Equatable {
//    
//    mutating func removeOrAppend(object: Base.Element) {
//        if base.contains(object) {
//            base.removeAll(where: { $0 == object })
//        } else {
//            base.append(object)
//        }
//    }
//    
//}
