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

// MARK: - Animation

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

// MARK: - Props

public extension GRActive where Base: UIView {

    var circleMaskImage: UIView {
        base.clipsToBounds = true
        base.layer.cornerRadius = base.frame.width / 2.0
        return base
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

#endif
