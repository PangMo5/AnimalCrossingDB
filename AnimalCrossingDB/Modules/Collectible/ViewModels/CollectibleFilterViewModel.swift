//
//  CollectibleFilterViewModel.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/15.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import SwifterSwift
import SwiftyUserDefaults

final class CollectibleFilterViewModel: ObservableObject {
    
    @Published var filter: CollectibleFilter
    var fromFish: Bool
    
    init(fromFish: Bool, filter: CollectibleFilter) {
        self.fromFish = fromFish
        self.filter = filter
    }
}
