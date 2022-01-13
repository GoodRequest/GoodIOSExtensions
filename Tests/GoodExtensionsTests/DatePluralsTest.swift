//
//  DatePluralsTest.swift
//  
//
//  Created by Andrej Jasso on 12/02/2022.
//

import XCTest
import GoodExtensions
import Foundation

final class DatePluralsTest: XCTestCase {

    enum C {

        static let testSet1 = [0,1,2,5]
        static let answerSet1Years =  (["rokov","rok","roky","rokov"], Calendar.Component.year)
        static let answerSet1Months = (["mesiacov","mesiac","mesiace","mesiacov"], Calendar.Component.month)
        static let answerSet1Days = (["dní","deň","dni","dní"], Calendar.Component.day)
        static let answerSet1Hours = (["hodín","hodina","hodiny","hodín"], Calendar.Component.hour)
        static let answerSet1Minutes = (["minút","minúta","minúty","minút"], Calendar.Component.minute)
        static let answerSet1Seconds = (["sekúnd","sekunda","sekundy","sekúnd"], Calendar.Component.second)
        static let answerSet1Units = [C.answerSet1Years, C.answerSet1Months, C.answerSet1Days, C.answerSet1Hours, C.answerSet1Minutes, C.answerSet1Seconds]

    }

    func testRemoveDiacritics() {
        C.answerSet1Units.forEach { answerSet in
            C.testSet1.enumerated().forEach { indexOfValue, testValue in
                let value = Date.gr.localizedPluralDateString(from: testValue, of: answerSet.1, with: .full, calendar: .sk_CET)
                let expectedValue = answerSet.0[indexOfValue]
                XCTAssert(
                    value == expectedValue,
                    "\(value) should be equal to \(expectedValue)"
                )
            }
           
        }
    }

}
