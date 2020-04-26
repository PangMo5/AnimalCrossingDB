//
//  ArtFilter.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/26.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct ArtFilter: GatherableFilter, Codable, DefaultsSerializable {
    
    var onlyFavorite: Bool = false
    var onlyGathered: Bool = false
    var onlyEndowmented: Bool = false
    var onlyNeedGathered: Bool = false
    
    func isEnableFilter() -> Bool {
        onlyFavorite ||
        onlyGathered ||
        onlyEndowmented ||
        onlyNeedGathered
    }
}
