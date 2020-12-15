//
//  File.swift
//  
//
//  Created by Dominik Pethö on 4/30/19.
//

#if !os(macOS)

import UIKit
import GRCompatible

public extension GRActive where Base: UIImageView {

    var cirleMaskImage: UIImageView {
        base.clipsToBounds = true
        base.layer.cornerRadius = base.frame.width / 2.0
        return base
    }

}

#endif
