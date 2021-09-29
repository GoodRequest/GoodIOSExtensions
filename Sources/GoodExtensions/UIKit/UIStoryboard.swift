//
//  UIStoryboard.swift
//  GoodExtensions
//
//  Created by Andrej Jasso on 29/09/2021.
//

#if !os(macOS)

import UIKit
import GRCompatible

public extension GRActive where Base: UIStoryboard {

    /**
     Creates a personalized greeting for a recipient.

     - Parameter recipient: The person being greeted.

     - Throws: `MyError.invalidRecipient`
               if `recipient` is "Derek"
               (he knows what he did).

     - Returns: A new string saying hello to `recipient`.
     */
    func instantiateViewController<T: UIViewController>(withClass clas: T.Type) -> T? {
        return base.instantiateViewController(withIdentifier: String(describing: clas)) as? T
    }

}

#endif
