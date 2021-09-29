//
//  ViewController.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//


import UIKit
import GRCompatible

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

