//
//  CGAffineTransform.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

#if !os(macOS)

import UIKit
import GRCompatible

extension CGAffineTransform: GRCompatible {}

public extension GRActive where Base == CGAffineTransform {

    static func create(
    	scale: CGFloat, translation: CGPoint, anchorPoint: CGPoint = .zero, for view: UIView
    ) -> CGAffineTransform {
        view.layer.anchorPoint = anchorPoint
        let scale = scale != 0 ? scale : CGFloat.leastNonzeroMagnitude
        let translationX = 1 / scale * (anchorPoint.x - 0.5) * (view.bounds.width - translation.x * 2)
        let translationY = 1 / scale * (anchorPoint.y - 0.5) * (view.bounds.height - translation.y * 2)
        return CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: translationX, y: translationY)
    }

}

#endif
