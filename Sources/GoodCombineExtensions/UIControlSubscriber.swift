//
//  UIControlSubscriber.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

#if !os(macOS)
import UIKit
import Combine

// swiftlint:disable line_length
@available(iOS 13.0, *)
final public class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
// swiftlint:enable line_length

    private var subscriber: SubscriberType?
    private weak var control: Control?

    init(subscriber: SubscriberType, control: Control?, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control

        control?.addTarget(self, action: #selector(eventHandler), for: event)
    }

    public func request(_ demand: Subscribers.Demand) {

    }

    public func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        guard let control = control else { return }
        _ = subscriber?.receive(control)
    }
}
#endif
