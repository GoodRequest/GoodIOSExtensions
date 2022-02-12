//
//  UIButtonExtensions.swift
//  
//
//  Created by Andrej Jasso on 12/02/2022.
//

import GRCompatible
import CoreGraphics

public extension GRActive where Base: UIButton {

    func applyClickableAreaInsets(by value: CGFloat) {
        base.contentEdgeInsets = UIEdgeInsets(
            top: value,
            left: value,
            bottom: value,
            right: value
        )
    }

}
