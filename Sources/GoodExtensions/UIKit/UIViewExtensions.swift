//
//  UIView.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//


import UIKit
import GRCompatible

// MARK: - Initialization from XIB

public extension UIView {
    
    static func loadFromNib() -> Self {
        return GRActive.loadNib(self)
    }
    
}

public extension GRActive where Base: UIView {
    
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
        // swiftlint:disable force_cast
        return nib.last as! A
        // swiftlint:enable force_cast
    }

    var frameWithoutTransform: CGRect {
        let center = base.center
        let size   = base.bounds.size

        return CGRect(
            x: center.x - size.width / 2,
            y: center.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }

}

// MARK: - Mask rendering

public extension GRActive where Base: UIView {

    var circleMaskImage: UIView {
        base.clipsToBounds = true
        base.layer.cornerRadius = base.frame.width / 2.0
        return base
    }

}

// MARK: - UIView InspectableAttributes

public extension UIView {

    /// View corner radius. Don't forget to set clipsToBounds = true
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    /// View border color
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.black.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }

    /// View border width
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// View's layer masks to bounds
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }

    /// View shadow opacity
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    /// View shadow color
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: layer.shadowColor ?? UIColor.black.cgColor)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }

    /// View shadow radius
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    /// View shadow offset
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

}

// MARK: - UIView Animations

public extension GRActive where Base: UIView {

    /// Animates shake with view
    func shakeView(duration: CFTimeInterval = 0.02, repeatCount: Float = 8.0, offset: CGFloat = 5.0) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: base.center.x - offset, y: base.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: base.center.x + offset, y: base.center.y))
        base.layer.add(animation, forKey: "position")
    }

    enum Rotate {

        case by0
        case by90
        case by180
        case by270
        case custom(Double)

        var rotationValue: Double {
            switch self {
            case .by0:
                return 0.0

            case .by90:
                return .pi / 2

            case .by180:
                return .pi

            case .by270:
                return .pi + .pi / 2

            case .custom(let value):
                return value
            }
        }

    }

    /// Rotates the view by specified angle.
    func rotate(_ rotateBy: Rotate) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.5,
            options: .beginFromCurrentState,
            animations: { [weak base] in
                base?.transform = CGAffineTransform(rotationAngle: CGFloat(rotateBy.rotationValue))
            }
        )
    }

}

public extension GRActive where Base: UIView {

    enum ViewAnimationType {

        case identity
        case show
        case hide

    }

    @discardableResult
    func animate(
        duration: TimeInterval,
        afterDelay: TimeInterval,
        dampingRatio: CGFloat? = nil,
        animationCurve: Base.AnimationCurve? = nil,
        animationType: ViewAnimationType
    ) -> UIViewPropertyAnimator {
        var animator = UIViewPropertyAnimator()

        if let dampingRatio = dampingRatio {
            animator = UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio)
        } else if let animationCurve = animationCurve {
            animator = UIViewPropertyAnimator(duration: duration, curve: animationCurve)
        }

        animator.addAnimations {
            switch animationType {
            case .identity:
                self.base.transform = .identity

            case .show:
                self.base.alpha = 1.0

            case .hide:
                self.base.alpha = 0.0
            }
        }

        animator.startAnimation(afterDelay: afterDelay)

        return animator
    }

}

// MARK: - Blur

public extension GRActive where Base: UIView {

    func blur(_ blurRadius: Double = 3.5) {
        unblur()
        guard let blurredImage = createBlurryImage(blurRadius) else {
            return
        }

        let blurredImageView = UIImageView(image: blurredImage)
        blurredImageView.translatesAutoresizingMaskIntoConstraints = false
        blurredImageView.tag = -419
        blurredImageView.contentMode = .center
        blurredImageView.backgroundColor = .clear

        base.addSubview(blurredImageView)
        NSLayoutConstraint.activate([
            blurredImageView.centerXAnchor.constraint(equalTo: base.centerXAnchor),
            blurredImageView.centerYAnchor.constraint(equalTo: base.centerYAnchor)
        ])
    }

    func unblur() {
        base.subviews.forEach {
            if $0.tag == -419 {
                $0.removeFromSuperview()
                base.layoutSubviews()
            }
        }
    }

    private func createBlurryImage(_ blurRadius: Double) -> UIImage? {
        UIGraphicsBeginImageContext(base.bounds.size)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        base.layer.render(in: currentContext)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
            let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()

        blurFilter.setDefaults()

        blurFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blurFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)

        var convertedImage: UIImage?
        let context = CIContext(options: nil)
        if let blurOutputImage = blurFilter.outputImage,
            let cgImage = context.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
            convertedImage = UIImage(cgImage: cgImage)
        }

        return convertedImage
    }

}

