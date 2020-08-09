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
    var type: CollectibleType
    
    init(type: CollectibleType, filter: CollectibleFilter) {
        self.type = type
        self.filter = filter
    }
}
