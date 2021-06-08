//
//  String.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Foundation
import GRCompatible

extension String: GRCompatible {}

public extension GRActive where Base == String {
    
    var attributed: NSMutableAttributedString {
        return NSMutableAttributedString(string: base, attributes: nil)
    }
    
    var removeWhiteSpacesAndNewlines: String {
        return base.components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    var removeDiacritics: String {
        return base.folding(options: .diacriticInsensitive, locale: .current)
    }

}
