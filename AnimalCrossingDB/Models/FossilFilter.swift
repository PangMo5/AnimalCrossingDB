//
//  FossilFilter.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/05/10.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct FossilFilter: GatherableFilter, Codable, DefaultsSerializable {
    
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
