//
//  ViewController.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//


import UIKit
import GRCompatible
import Combine

// MARK: - Embedable

public extension GRActive where Base: UIViewController {
    
    func embed(viewController: UIViewController, in containerView: UIView) {
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        base.addChild(viewController)
        viewController.didMove(toParent: base)
    }
    
}

// MARK: - Instantiable

public extension GRActive where Base: UIViewController {
    
    static func makeInstance(name: String? = nil) -> Base {
        var viewControllerName: String
        if let name = name {
            viewControllerName = name
        } else {
            viewControllerName = Base.gr.typeName
        }
        
        let storyboard = UIStoryboard(name: viewControllerName, bundle: nil)
        guard let instance = storyboard.instantiateInitialViewController() as? Base
                ?? instantiate(storyboard: storyboard, name: viewControllerName)
        else { fatalError("Could not make instance of \(String(describing: Base.self))") }
        return instance
    }
    
    private static func instantiate(storyboard: UIStoryboard, name: String) -> Base? {
        if #available(iOS 13.0, *) {
            return storyboard.instantiateViewController(identifier: name) as? Base
        } else {
            return nil
        }
    }
    
}

public extension GRActive where Base: UIViewController {

    struct KeyboardInfo: Equatable {

        public static func == (lhs: KeyboardInfo, rhs: KeyboardInfo) -> Bool {
            return lhs.height == rhs.height
        }

        let height: CGFloat
        let duration: Double
        let curve: UIView.AnimationCurve

        static var emptyInfo: KeyboardInfo { KeyboardInfo(height: 0.0, duration: 0.0, curve: .linear) }

    }

    enum KeyboardState: Equatable {

        case hidden(KeyboardInfo)
        case expanded(KeyboardInfo)

    }

    var keyboardStatePublisher: AnyPublisher<KeyboardState, Never> {
        let showNotification = UIApplication.keyboardWillShowNotification
        let keyboardWillShowPublisher = NotificationCenter.default.publisher(for: showNotification)
            .map { keyboard -> KeyboardState in
                let height = (keyboard.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
                let duration = (keyboard.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.5
                let curve = (keyboard.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UIView.AnimationCurve) ?? .linear
                let info = KeyboardInfo(height: height, duration: duration, curve: curve)
                return .expanded(info)
            }

        let hideNotification = UIApplication.keyboardWillHideNotification
        let keyboardWillHidePublisher = NotificationCenter.default.publisher(for: hideNotification)
            .map { keyboard -> KeyboardState in
                let height = 0.0
                let duration = (keyboard.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat) ?? 0.5
                let curve = (keyboard.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UIView.AnimationCurve) ?? .linear
                let info = KeyboardInfo(height: height, duration: duration, curve: curve)
                return .hidden(info)
            }

        return Publishers.Merge(keyboardWillShowPublisher, keyboardWillHidePublisher)
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> { keyboardStatePublisher.map { $0.height } }
    
}
