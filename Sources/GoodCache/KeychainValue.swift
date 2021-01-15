//
//  UserDefaults.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Foundation
import Combine
import CombineExt

@available(iOS 13.0, *)
@propertyWrapper
public class KeychainValue<T: Codable> {

    private struct Wrapper: Codable {
        let value: T
    }

    private let subject: PassthroughSubject<T, Never> = PassthroughSubject()
    private let key: String
    private let defaultValue: T
    private let accessibility: KeychainItemAccessibility?

    public init(_ key: String, defaultValue: T, accessibility: KeychainItemAccessibility? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.accessibility = accessibility
    }

    public var wrappedValue: T {
        get {
            guard let data = KeychainWrapper.standard.data(forKey: key, withAccessibility: accessibility) else { return defaultValue }
            let value = (try? PropertyListDecoder().decode(Wrapper.self, from: data))?.value ?? defaultValue            
            
            return value
        }

        set(newValue) {            
            let wrapper = Wrapper(value: newValue)
            
            guard let data = try? PropertyListEncoder().encode(wrapper) else {
                KeychainWrapper.standard.removeObject(forKey: key)
                return
            }

            KeychainWrapper.standard.set(data, forKey: key, withAccessibility: accessibility)

            subject.send(newValue)
        }
    }

    public lazy var publisher: AnyPublisher<T, Never> = {
        Deferred {
            self.subject
                .prepend(self.wrappedValue)
                .share(replay: 1)
        }.eraseToAnyPublisher()
    }()

}
