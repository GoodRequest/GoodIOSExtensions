//
//  URL.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Foundation
import GRCompatible

public extension GRActive where Base == URL {

    var formatted: String? {
        guard let components = URLComponents(url: base, resolvingAgainstBaseURL: false),
              let scheme = components.scheme,
              let host = components.host else {
            return base.absoluteString
        }
        return "\(scheme)://\(host)"
    }

}
