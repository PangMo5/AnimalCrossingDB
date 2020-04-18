//
//  CollectibleFilter.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/15.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct CollectibleFilter: Codable, DefaultsSerializable {
    
    var onlyFavorite: Bool = false
    var onlyGathered: Bool = false
    var onlyEndowmented: Bool = false
    var onlyAvailable: Bool = false
    var onlyDisavailable: Bool = false
    var month: Int?
    var fishSize: Fish.Size?
    var fishArea: Fish.Area?
    var insectArea: Insect.Area?
    
    func isEnableFilter(fromFish: Bool) -> Bool {
        onlyFavorite ||
        onlyGathered ||
        onlyEndowmented ||
        month != nil ||
        (fishSize != nil && fromFish) ||
        (fishArea != nil && fromFish) ||
        (insectArea != nil && !fromFish)
    }
}
