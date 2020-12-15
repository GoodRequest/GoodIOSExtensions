//
//  Collection.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Foundation
import GRCompatible

public extension GRActive where Base == Swift.Optional<Collection> {
    
    var isNilOrEmpty: Bool {
        switch base {
        case let value?:
            return value.isEmpty
        default:
            return true
        }
    }
    
}
