//
//  CGFloatExtensions.swift
//  
//
//  Created by Andrej Jasso on 24/01/2022.
//

import CoreGraphics
import GRCompatible

public extension CGFloat {
    
    // MARK: - Alpha stages

    static var translucent: CGFloat { GRActive.discreetZero }

    static var solid: CGFloat { GRActive.discreetOne }
    
}


extension CGFloat: GRCompatible {}

public extension GRActive where Base == CGFloat {
    
    static var discreetZero: CGFloat { .zero }
    static var discreetOne: CGFloat {
        1.0
    }

    // MARK: - Clamping

    var discreetClamped: CGFloat {
        return clamped(lowerBound: GRActive.discreetZero, upperBound: GRActive.discreetOne)
    }

    func clamped(lowerBound: CGFloat, upperBound: CGFloat) -> CGFloat {
        if base <= lowerBound {
            return lowerBound
        } else if base >= upperBound {
            return upperBound
        }
        return base
    }

}
