//
//  Gatherable.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/26.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation

protocol Gatherable {
    
    var isFavorite: Bool { get }
    var isGathered: Bool { get }
    var isEndowmented: Bool { get }
    
    func switchFavorite()
    func switchGathering()
    func switchEndowment()
}
