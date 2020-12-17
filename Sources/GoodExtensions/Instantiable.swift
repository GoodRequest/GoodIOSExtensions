//
//  Instantiable.swift
//  
//
//  Created by Dominik Pethö on 4/30/19.
//

#if !os(macOS)
import UIKit

public protocol Instantiable {
    static func makeInstance(name: String?) -> Self
}

public extension Instantiable where Self: UIViewController {
    /// Instantiates controller from storyboard.
    /// - example:
    /// `let myViewController = MyViewController.makeInstance()`
    /// - important:
    /// Initial controller of the same type must exists in storyboard named as controller's
    /// class without "ViewController" suffix, otherwise will `fatalError()`.
    /// - Returns: Instantiated view controller.
    static func makeInstance(name: String? = nil) -> Self {
        var viewControllerName: String
        if let name = name {
            viewControllerName = name
        } else {
            viewControllerName = gr.typeName
        }

        let storyboard = UIStoryboard(name: viewControllerName, bundle: nil)
        guard let instance =
            storyboard.instantiateInitialViewController() as? Self
            ?? instantiate(storyboard: storyboard, name: viewControllerName)
            
            else { fatalError("Could not make instance of \(String(describing: self))") }
        return instance
    }
    
    private static func instantiate(storyboard: UIStoryboard, name: String) -> Self? {
        if #available(iOS 13.0, *) {
            return storyboard.instantiateViewController(identifier: name) as? Self
        } else {
            return nil
        }
    }
}

extension UIViewController: Instantiable {}
#endif
