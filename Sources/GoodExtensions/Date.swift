//
//  File.swift
//
//
//  Created by Andrej Jasso on 08/06/2021.
//

import Foundation
import GRCompatible

public extension GRActive where Base == Date {

    func adding(number: Int, of component: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: component, value: number, to: base) ?? base
    }

}
