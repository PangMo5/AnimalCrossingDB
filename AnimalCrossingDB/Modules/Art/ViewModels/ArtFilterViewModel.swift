//
//  ArtFilterViewModel.swift
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

final class ArtFilterViewModel: ObservableObject {
    
    @Published var filter: ArtFilter
    
    init(filter: ArtFilter) {
        self.filter = filter
    }
}
