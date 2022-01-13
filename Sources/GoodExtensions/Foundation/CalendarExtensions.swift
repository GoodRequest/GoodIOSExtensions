//
//  CalendarExtensions.swift
//  GoodExtensions
//
//  Created by Andrej Jasso on 12/02/2022.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

public extension Calendar {

    static var sk_CET: Calendar {
        if let calendar = sk_CET_calendar {
            return calendar
        } else {
            var calendar = Calendar(identifier: .gregorian)
            if let timezone = TimeZone(identifier: timeZoneCETIdentifier) {
                calendar.timeZone = timezone
            }
            calendar.locale = Locale(identifier: localeIndentifierSK)
            sk_CET_calendar = calendar
            return calendar
        }
    }

    private static var sk_CET_calendar: Calendar?

    static let timeZoneCETIdentifier = "CET"
    static let localeIndentifierSK = "sk"

}
