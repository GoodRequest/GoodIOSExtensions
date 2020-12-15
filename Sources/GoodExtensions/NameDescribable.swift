//
//  NameDescribable.swift
//  
//
//  Created by Dominik Pethö on 4/30/19.
//

import Foundation
import GRCompatible

public protocol NameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}

public extension GRActive where Base: NSObject {
    
    var typeName: String {
        return String(describing: type(of: self))
    }

    static var typeName: String {
        return String(describing: self)
    }
    
}

extension Array: GRCompatible {}

public extension GRActive where Base: Collection {
    
    var typeName: String {
        return String(describing: type(of: self))
    }

    static var typeName: String {
        return String(describing: self)
    }
    
}

