//
//  UIView.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

#if !os(macOS)

import UIKit
import GRCompatible

public extension GRActive where Base: UIView {
    
    static func loadFromNib() -> Self {
        return loadNib(Base.self)
    }
        
    static func loadNib<A>(_ owner: AnyObject, bundle: Bundle = Bundle.main) -> A {
        guard let nibName = NSStringFromClass(Base.classForCoder()).components(separatedBy: ".").last else {
            fatalError("Class name [\(NSStringFromClass(Base.classForCoder()))] has no components.")
        }
        
        guard let nib = bundle.loadNibNamed(nibName, owner: owner, options: nil) else {
            fatalError("Nib with name [\(nibName)] doesn't exists.")
        }
        for item in nib {
            if let item = item as? A {
                return item
            }
        }
        return nib.last as! A
    }

    var frameWithoutTransform: CGRect {
        let center = base.center
        let size   = base.bounds.size
        
        return CGRect(x: center.x - size.width  / 2,
                      y: center.y - size.height / 2,
                      width: size.width,
                      height: size.height)
    }
    
}

// MARK: - Animation

public extension GRActive where Base: UIView {
    
    enum ViewAnimationType {
        
        case identity
        case show
        case hide
        
    }
    
    @discardableResult
    func animate(duration: TimeInterval,
                 afterDelay: TimeInterval,
                 dampingRatio: CGFloat? = nil,
                 animationCurve: Base.AnimationCurve? = nil,
                 animationType: ViewAnimationType) -> UIViewPropertyAnimator {
        
        var animator = UIViewPropertyAnimator()
        
        if let dampingRatio = dampingRatio {
            animator = UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio)
        } else if let animationCurve = animationCurve {
            animator = UIViewPropertyAnimator(duration: duration, curve: animationCurve)
        }
                        
        animator.addAnimations {
            switch animationType {
            case .identity:
                base.transform = .identity
            case .show:
                base.alpha = 1.0
            case .hide:
                base.alpha = 0.0
            }
        }
        
        animator.startAnimation(afterDelay: afterDelay)
        
        return animator
    }
    
}

#endif
