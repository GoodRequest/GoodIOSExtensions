//
//  NSCollectionLayoutGroup.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//
#if !os(macOS)

import UIKit
import GRCompatible

@available(iOS 13.0, *)
public extension GRActive where Base: NSCollectionLayoutGroup {

    static func horizontalWithDimensions(
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension
    ) -> NSCollectionLayoutGroup {
        let itemSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)

        return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    }

}

#endif
