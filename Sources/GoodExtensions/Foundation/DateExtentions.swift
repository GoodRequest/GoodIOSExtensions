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
    Adding returns a new date with the added component
     - parameter number: Number of component value to be added
     - parameter component: Component to add
     - returns: New date with added component
     */
    func adding(number: Int, of component: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: component, value: number, to: base) ?? base
    }

    /**
    Subtracting returns a new date with the subtracted component
     - parameter number: Number of component value to be subtracted
     - parameter component: Component to add
     - returns: New date with subracted component
     */
    func subtracting(number: Int, of component: Calendar.Component) -> Date {
        return adding(number: -number, of: component)
    }

    /**
     localizedPluralDateString returns a localized string
     - parameter number: Number of component value to be added
     - parameter component: Component to add
     - parameter style: DateComponentsFormatter.UnitsStyle
     - returns: Second part of the string with from localized date string
     */
    static func localizedPluralDateString(
        from number: Int,
        of component: Calendar.Component,
        calendar: Calendar = .sk_CET
    ) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        let fromDate = Date()
        let toDate = fromDate.gr.adding(number: number, of: component)

        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [component],
            from: fromDate,
            to: toDate
        )
        if let substring = formatter.string(from: components)?.split(separator: " ")[safe: 1] {
            return String(substring)
        }
        return String("\(component)")
    }

}
