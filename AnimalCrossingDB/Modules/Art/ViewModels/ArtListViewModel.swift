//
//  ArtListViewModel.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/26.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class ArtListViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @Published fileprivate var refresh = false
    
    @Published var artList = [Art]()
    
    @Published var searchText = ""
    
    init() {
        Refresher.shared.collectibleFlagableRefreshSubject.assign(to: \.refresh, on: self).store(in: &disposables)
        
        StorageManager.shared.artListSubject
            .map { $0.sorted(by: \.id) }
            .print()
            .assign(to: \.artList, on: self)
            .store(in: &disposables)
    }
}
