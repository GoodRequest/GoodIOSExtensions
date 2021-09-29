//
//  File.swift
//
//
//  Created by Andrej Jasso on 08/06/2021.
//

import Foundation
import GRCompatible

extension Date: GRCompatible {}

public extension GRActive where Base == Date {

    /**
    Adding return a new date with the added component
     - parameter number: Number of component value to be added
     - parameter component: Component to add
     - returns: New date with added component
     */
    func adding(number: Int, of component: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: component, value: number, to: base) ?? base
    }

}
