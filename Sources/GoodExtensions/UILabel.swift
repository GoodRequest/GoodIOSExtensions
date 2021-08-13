//
//  UILabel.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

#if !os(macOS)

import UIKit
import GRCompatible

public extension GRActive where Base: UILabel {

    var isTruncated: Bool {
        return base.intrinsicContentSize.width > base.bounds.width
    }

}

#endif
