//
//  UIApplication.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//
#if !os(macOS)

import UIKit
import MapKit
import GRCompatible

public enum UIApplicationUrlType {

    case instagramMedia(id: String)
    case telepromt(number: String)
    case settings

}

public extension GRActive where Base: UIApplication {

    @available(iOS 13.0, *)
    var currentStatusBarFrame: CGRect? {
        return base.windows.filter({ $0.isKeyWindow }).first?.windowScene?.statusBarManager?.statusBarFrame
    }

    var canOpenInstagram: Bool {
        return base.canOpenURL(URL(string: "instagram://")!)
    }

    func open(_ urlType: UIApplicationUrlType) {
        switch urlType {
        case .instagramMedia(let id):
            safeOpen(URL(string: "instagram://media?id=\(id)"))
        case .telepromt(let number):
            safeOpen(URL(string: "telprompt://\(number.gr.removeWhiteSpacesAndNewlines)"))
        case .settings:
            safeOpen(URL(string: UIApplication.openSettingsURLString))
        }
    }

    func safeOpen(_ url: URL?, options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
        if let url = url, base.canOpenURL(url) {
            base.open(url, options: options, completionHandler: completion)
        }
    }

}

#endif
