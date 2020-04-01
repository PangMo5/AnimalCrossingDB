//
//  FishListViewModel.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/03/31.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import SwifterSwift

final class FishListViewModel: ObservableObject {
    
    private var disposables = Set<AnyCancellable>()
    
    @Published var searchText = ""
    
    @Published var availableFishList = [Fish]()
    @Published var disavailableFishList = [Fish]()
    
    init() {
        let sortedFishList = StorageManager.shared.fishListSubject
            .map { $0.sorted { ($0.id ?? 0) > ($1.id ?? 0) } }
        
        let filteredFishList = Publishers.CombineLatest($searchText, sortedFishList)
            .map { text, fishList in
                fishList.filter {
                    ($0.name?.lowercased().contains(text.lowercased()) ?? false)
                        || ($0.englishName?.lowercased().contains(text.lowercased()) ?? false)
                        || text.isEmpty
                }
        }
        
        filteredFishList
            .map { $0.filter(\.isAvailable) }
            .assign(to: \.availableFishList, on: self).store(in: &disposables)
        
        filteredFishList
            .map { $0.filter { !$0.isAvailable } }
            .assign(to: \.disavailableFishList, on: self).store(in: &disposables)
    }
}
