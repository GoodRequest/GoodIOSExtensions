//
//  UserDefaultsWrapper.swift
//  
//
//  Created by Dominik Pethö on 1/15/21.
//

import Foundation
import Combine
import CombineExt

@available(iOS 13.0, *)
@propertyWrapper
public class UserDefaultValue<T: Codable> {

    struct Wrapper: Codable {
        let value: T
    }

    private let subject: PassthroughSubject<T, Never> = PassthroughSubject()
    private let key: String
    private let defaultValue: T

    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            if let data = UserDefaults.standard.value(forKey: key) as? T {
                return data
            }

            guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return defaultValue }
            let value = (try? PropertyListDecoder().decode(Wrapper.self, from: data))?.value ?? defaultValue

            return value
        }
        set(newValue) {
            let wrapper = Wrapper(value: newValue)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(wrapper), forKey: key)

            subject.send(newValue)
        }
    }

    public lazy var publisher: AnyPublisher<T, Never> = {
        subject.prepend(wrappedValue)
            .share(replay: 1)
            .eraseToAnyPublisher()
    }()

}

