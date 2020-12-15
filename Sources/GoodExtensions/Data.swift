//
//  Data.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Foundation
import GRCompatible

public extension GRActive where Base == Data {

    var hexString: String {
        return base.map { data -> String in
            return String(format: "%02.2hhx", data)
        }.joined()
    }

}
