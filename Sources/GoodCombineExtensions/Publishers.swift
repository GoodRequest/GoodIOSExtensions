//
//  Publishers.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Combine
import GRCompatible

@available(iOS 13.0, *)
public extension Publisher where Self: GRCompatible {}

@available(iOS 13.0, *)
public extension GRActive where Base: Publisher {

    func combineWith<Output2: AnyObject>(_ value: Output2) -> AnyPublisher<(Base.Output, Output2), Base.Failure> {
        base.compactMap { [weak value] currentValue in
            guard let value = value else { return nil }
            return (currentValue, value)
        }.eraseToAnyPublisher()
    }

    func combineWith<Output2: AnyObject, Output3: AnyObject>(
        _ value: Output2,
        _ value2: Output3
    ) -> AnyPublisher<(Base.Output, Output2, Output3), Base.Failure> {
        base.compactMap { [weak value, weak value2] currentValue in
            guard let value = value, let value2 = value2 else { return nil }
            return (currentValue, value, value2)
        }.eraseToAnyPublisher()
    }

    func with<Output: AnyObject>(_ value: Output) -> AnyPublisher<Output, Base.Failure> {
        base.compactMap { [weak value] _ in value }.eraseToAnyPublisher()
    }

    func with<Output: AnyObject, Output2: AnyObject>(
        _ value: Output,
        _ value2: Output2
    ) -> AnyPublisher<(Output, Output2), Base.Failure> {
        base.compactMap { [weak value, weak value2] _ in
            guard let value = value, let value2 = value2 else { return nil }
            return (value, value2)
        }.eraseToAnyPublisher()
    }

}

@available(iOS 13.0, *)
public extension Publisher where Failure == Never {

    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
       sink { [weak root] in
            root?[keyPath: keyPath] = $0
       }
    }

}
