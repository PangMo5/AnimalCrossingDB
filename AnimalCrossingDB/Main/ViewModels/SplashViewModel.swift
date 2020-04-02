//
//  SplashViewModel.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/02.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class SplashViewModel: ObservableObject {
    
    @Published var response: StorageManager.StaticResponse?
    
    init() {
        StorageManager.shared.fetchStaticData { [weak self] response in
            self?.response = response
        }
    }
}
