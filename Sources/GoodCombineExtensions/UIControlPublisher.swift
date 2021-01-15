//
//  UIControlPublisher.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

#if !os(macOS)
import UIKit
import Combine
import GRCompatible

@available(iOS 13.0, *)
public struct UIControlPublisher<Control: UIControl>: Publisher {

    public typealias Output = Control
    public typealias Failure = Never

    weak var control: Control?
    let event: UIControl.Event

    init(control: Control, event: UIControl.Event) {
        self.control = control
        self.event = event
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber,
                                         S.Failure == UIControlPublisher.Failure,
                                         S.Input == UIControlPublisher.Output {
        let subscription = UIControlSubscription(
            subscriber: subscriber,
            control: control,
            event: event
        )
        subscriber.receive(subscription: subscription)
    }
}

@available(iOS 13.0, *)
public extension GRActive where Base: UIControl {
    
    func publisher(for event: UIControl.Event) -> UIControlPublisher<UIControl> {
        UIControlPublisher(control: base, event: event)
    }
    
}

#endif
