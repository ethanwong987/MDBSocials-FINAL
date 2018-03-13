//
//  LyftHelper.swift
//  MDBSocials
//
//  Created by Ethan Wong on 3/3/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import Foundation
import LyftSDK
import CoreLocation
class LyftHelper {
    
    static func getRideEstimate(pickup: CLLocationCoordinate2D, dropoff: CLLocationCoordinate2D, withBlock: @escaping ((Cost)) -> ()){
        LyftAPI.costEstimates(from: pickup, to: dropoff, rideKind: .Standard) { result in
            result.value?.forEach { costEstimate in
                withBlock(costEstimate)
            }
        }
    }
}
