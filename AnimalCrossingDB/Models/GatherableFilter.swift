//
//  GatherableFilter.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/26.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation

protocol GatherableFilter {
    
    var onlyFavorite: Bool { get set }
    var onlyGathered: Bool { get set }
    var onlyEndowmented: Bool { get set }
    var onlyNeedGathered: Bool { get set }
}
