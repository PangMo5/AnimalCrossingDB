//
//  FossilFilterViewModel.swift
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

final class FossilFilterViewModel: ObservableObject {
    
    @Published var filter: FossilFilter
    
    init(filter: FossilFilter) {
        self.filter = filter
    }
}
