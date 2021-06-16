//
//  LossyCodableList.swift
//  sfzfans
//
//  Created by Andrej Jasso on 16/06/2021.
//  Copyright © 2021 GoodRequest. All rights reserved.
//

import Foundation

@propertyWrapper
struct LossyCodableArray<Element>: Equatable where Element: Equatable {

    var elements: [Element]

    var wrappedValue: [Element] {
        get { elements }
        set { elements = newValue }
    }

}

extension LossyCodableArray: Decodable where Element: Decodable & Equatable {

    private struct ElementWrapper: Decodable {

        var element: Element?

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            element = try? container.decode(Element.self)
        }

    }

    init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer() {
            let wrappers = try container.decode([ElementWrapper].self)
            elements = wrappers.compactMap(\.element)
        } else {
            self.elements = [Element]()
        }
    }

}

extension LossyCodableArray: Encodable where Element: Encodable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()

        for element in elements { try? container.encode(element) }
    }

}
