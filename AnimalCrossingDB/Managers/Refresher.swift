//
//  Refresher.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/05.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import Combine

final class Refresher {
    
    static let shared = Refresher()
    
    var collectibleFlagableRefreshSubject = PassthroughSubject<Bool, Never>()
    var collectibleFilterRefreshSubject = PassthroughSubject<CollectibleFilter, Never>()
}

