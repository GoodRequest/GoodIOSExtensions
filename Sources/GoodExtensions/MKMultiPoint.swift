//
//  MKMultiPoint.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import MapKit
import GRCompatible

extension GRActive where Base == MKMultiPoint {
    
    var points: [MKMapPoint] {
        return Array(UnsafeBufferPointer(start: base.points(), count: base.pointCount))
    }
    
}

