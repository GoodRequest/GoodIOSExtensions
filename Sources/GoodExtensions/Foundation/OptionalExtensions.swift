//
//  OptionalExtensions.swift
//  
//
//  Created by Andrej Jasso on 24/01/2022.
//

import Foundation

public extension Optional {

    var isNotNil: Bool { self != nil }
    var isNil: Bool { self == nil }

}
