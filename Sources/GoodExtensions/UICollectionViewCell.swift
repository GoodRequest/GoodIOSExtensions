//
//  UICollectionViewCell.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

#if !os(macOS)

import UIKit
import GRCompatible

public extension GRActive where Base: UICollectionViewCell {

    func animate(selected: Bool) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: .zero,
            options: .beginFromCurrentState,
            animations: { [weak base] in
                base?.contentView.transform = selected ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            },
            completion: nil)
    }

}

#endif
