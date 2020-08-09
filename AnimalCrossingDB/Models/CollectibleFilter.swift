//
//  CollectibleFilter.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/15.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct CollectibleFilter: GatherableFilter, Codable, DefaultsSerializable {
    
    var onlyFavorite: Bool = false
    var onlyGathered: Bool = false
    var onlyEndowmented: Bool = false
    var onlyNeedGathered: Bool = false
    var onlyAvailable: Bool = false
    var onlyDisavailable: Bool = false
    var month: Int?
    var seafoodSize: Seafood.Size?
    var fishSize: Fish.Size?
    var fishArea: Fish.Area?
    var insectArea: Insect.Area?
    
    func isEnableFilter(type: CollectibleType) -> Bool {
        onlyFavorite ||
            onlyGathered ||
            onlyEndowmented ||
            onlyNeedGathered ||
            month != nil ||
            (fishSize != nil && type == .fish) ||
            (fishArea != nil && type == .fish) ||
            (insectArea != nil && type == .insect)
    }
}
