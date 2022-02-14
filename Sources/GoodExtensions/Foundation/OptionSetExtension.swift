//
//  OptionSetExtension.swift
//  GoodExtensions
//
//  Created by Filip Šašala on 14/02/2022.
//  Copyright © 2022 GoodRequest. All rights reserved.
//

import Foundation

/// Add respective binary-equivalent operations to bitset type
public extension OptionSet {
    
    /// Performs union of two bitsets, represented by bitwise OR
    /// - Parameter lhs: Left side operand
    /// - Parameter rhs: Right side operand
    /// - Returns: Union of bitsets in parameters
    static func | (lhs: Self, rhs: Self) -> Self {
        lhs.union(rhs)
    }
    
    /// Performs symmetric difference between two bitsets,
    /// represented by bitwise AND
    /// - Parameter lhs: Left side operand
    /// - Parameter rhs: Right side operand
    /// - Returns: Intersection between bitsets in parameters
    static func & (lhs: Self, rhs: Self) -> Self {
        lhs.intersection(rhs)
    }
    
    /// Performs symmetric difference between two bitsets,
    /// represented by bitwise XOR
    /// - Parameter lhs: Left side operand
    /// - Parameter rhs: Right side operand
    /// - Returns: Symmetric difference between bitsets in parameters
    static func ^ (lhs: Self, rhs: Self) -> Self {
        lhs.symmetricDifference(rhs)
    }

}
