//
//  UIDevice.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

#if !os(macOS)

import UIKit
import GRCompatible

public extension GRActive where Base: UIDevice {
    
    var device: GRDevice {
        GRDevice(
            deviceId: base.identifierForVendor?.uuidString ?? "",
            deviceSystem: "\(base.systemName) \(base.systemVersion)",
            deviceName: base.name,
            deviceType: base.model
        )
    }
    
}

public struct GRDevice {
    
    let deviceId: String
    let deviceSystem: String
    let deviceName: String
    let deviceType: String
    
}

#endif
