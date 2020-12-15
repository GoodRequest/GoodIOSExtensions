//
//  UILabel.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

#if !os(macOS)

import UIKit

extension UILabel {
    
    var isTruncated: Bool {
        return intrinsicContentSize.width > bounds.width
    }
    
}

#endif
