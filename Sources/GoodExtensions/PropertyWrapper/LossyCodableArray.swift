//
//  LossyCodableList.swift
//
//
//  Created by Andrej Jasso on 16/06/2021.
//

import Foundation

/**
 Lossy codable array compact maps array results when parsing decodable input.
 *  Default value is an empty array
 *  Cannot apply on top of optional arrays
 *  Cannot  on top of constants
 *  Errors in decoding are printed into the console in a structured way
*/
@propertyWrapper
public struct LossyCodableArray<Element>: Equatable where Element: Equatable {

    public var elements: [Element]

    public var wrappedValue: [Element] {

        get {
            elements
        }

        set {
            elements = newValue
        }

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

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer() {
            let wrappers = try container.decode([ElementWrapper].self)
            elements = wrappers.compactMap(\.element)
            if elements.count != wrappers.count {
                handleErrorLog(wrappers: wrappers)
            }
        } else {
            self.elements = [Element]()
        }
    }

    private func handleErrorLog(wrappers: [ElementWrapper]) {
        wrappers.enumerated().filter {
            $0.element.element == nil
        }.forEach {
            print("\n❌ Failed to parse element \($0.element) at index: \($0.offset)")
        }
        wrappers.enumerated().map { wrapper -> String in
            if let element =  wrapper.element.element {
                return "\(wrapper.offset) : \(String(String(describing: element).split(separator: ".").last ?? "Wrong format"))"
            } else {
                return "\(wrapper.offset) : nil"
            }
        }.forEach {
            print("\($0)")
        }
    }

}

extension LossyCodableArray: Encodable where Element: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()

        for element in elements {
            try? container.encode(element)
        }
    }

}
